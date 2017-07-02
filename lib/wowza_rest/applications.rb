require 'json'
module WowzaRest
  module Applications
    def applications
      connection.request(:get, '/applications').parsed_response
    end

    def get_application(app_name)
      response = connection.request(:get, "/applications/#{app_name}")
      response.response.code == '200' ? response.parsed_response : nil
    end

    def create_application(app_body)
      unless app_body.include?(:name) && app_body.include?(:appType)
        raise WowzaRest::Errors::MissingRequiredKeys,
              '{ name } and/or { appType } Keys on application hash is required'
      end
      connection.request(:post, '/applications', body: app_body.to_json)
    end

    def update_application(app_name, fields)
      apply_update_application_checks(app_name, fields)
      connection.request(:put, "/applications/#{app_name}",
                         body: fields.to_json)['success']
    end

    private

    # rubocop:disable Metrics/LineLength
    def apply_update_application_checks(app_name, fields)
      if !app_name.is_a?(String)
        raise WowzaRest::Errors::InvalidArgumentType,
              "First argument expected to be String got #{app_name.class} instead"
      elsif !fields.is_a?(Hash)
        raise WowzaRest::Errors::InvalidArgumentType,
              "Second argument expected to be String got #{fields.class} instead"
      elsif fields.empty?
        raise WowzaRest::Errors::InvalidArgument,
              'Fields hash must have at least one attribute'
      end
    end
    # rubocop:enable Metrics/LineLength
  end
end
