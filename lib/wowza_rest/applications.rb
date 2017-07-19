require_relative 'data/application'
require_relative 'data/application_short'

module WowzaRest
  module Applications
    def applications
      response = connection.request(:get, '/applications')
      return unless response.code == 200
      response.parsed_response['applications']
              .map { |e| WowzaRest::Data::ApplicationShort.new(e) }
    end

    def get_application(app_name)
      response = connection.request(:get, "/applications/#{app_name}")
      return unless response.code == 200
      WowzaRest::Data::Application.new(response.parsed_response)
    end
    alias application get_application

    def create_application(app_body, use_default_config = true)
      unless app_body.include?(:name) && app_body.include?(:appType)
        raise WowzaRest::Errors::MissingRequiredKeys,
              '{ name } and/or { appType } Keys on application hash is required'
      end
      if use_default_config
        app_body = default_application_config.merge(app_body)
      end
      connection.request(:post, '/applications', body: app_body.to_json)
    end

    def update_application(app_name, config)
      apply_update_application_checks(app_name, config)
      connection.request(:put, "/applications/#{app_name}",
                         body: config.to_json)['success']
    end

    def delete_application(app_name)
      unless app_name.is_a?(String)
        raise WowzaRest::Errors::InvalidArgumentType,
              "First argument expected to be String got #{app_name.class}"
      end
      connection.request(:delete, "/applications/#{app_name}")['success']
    end

    def get_application_stats(app_name)
      unless app_name.is_a?(String)
        raise WowzaRest::Errors::InvalidArgumentType,
              "First argument expected to be String got #{app_name.class}"
      end
      response = connection.request(
        :get, "/applications/#{app_name}/monitoring/current"
      )
      return unless response.code == 200
      WowzaRest::Data::ApplicationStats.new(response.parsed_response)
    end

    private

    # rubocop:disable Metrics/LineLength
    # rubocop:disable Metrics/MethodLength
    def apply_update_application_checks(app_name, config)
      if !app_name.is_a?(String)
        raise WowzaRest::Errors::InvalidArgumentType,
              "First argument expected to be String got #{app_name.class} instead"
      elsif !config.is_a?(Hash) && !config.is_a?(WowzaRest::Data::Application)
        raise WowzaRest::Errors::InvalidArgumentType,
              "Second argument expected to be Hash or WowzaRest::Data::Application instance,
              got #{config.class} instead"
      elsif config.is_a?(Hash) && config.empty?
        raise WowzaRest::Errors::InvalidArgument,
              'When Configuration passeed as hash it must contains at least one attribute'
      end
    end
    # rubocop:enable Metrics/LineLength
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/LineLength
    def default_application_config
      {
        clientStreamWriteAccess: '*',
        httpCORSHeadersEnabled: true,
        securityConfig: {
          clientStreamWriteAccess: '*',
          publishRequirePassword: true,
          publishAuthenticationMethod: 'digest'
        },
        streamConfig: {
          streamType: 'live',
          liveStreamPacketizer: %w[cupertinostreamingpacketizer mpegdashstreamingpacketizer sanjosestreamingpacketizer smoothstreamingpacketizer]
        },
        modules: {
          moduleList: [
            {
              'order' => 0,
              'name' => 'ModuleCoreSecurity',
              'description' => 'Core Security Module for Applications',
              'class' => 'com.wowza.wms.security.ModuleCoreSecurity'
            }
          ]
        }

      }
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/LineLength
  end
end
