require_relative 'data/instance'
require_relative 'data/incoming_stream_stats'

module WowzaRest
  module Instances
    def instances(app_name)
      response = connection.request(
        :get, "/applications/#{app_name}/instances"
      )
      return unless response.code == 200
      response.parsed_response['instanceList']
              .map { |e| WowzaRest::Data::Instance.new(e) }
    end

    def get_instance(app_name, instance_name = '_definst_')
      response = connection.request(
        :get, "/applications/#{app_name}/instances/#{instance_name}"
      )
      return unless response.code == 200
      WowzaRest::Data::Instance.new(response.parsed_response)
    end

    # rubocop:disable Metrics/LineLength
    def get_incoming_stream_stats(app_name, stream_name, instance_name = '_definst_')
      response = connection.request(
        :get, "/applications/#{app_name}/instances/#{instance_name}/incomingstreams/#{stream_name}/monitoring/current"
      )
      return unless response.code == 200
      WowzaRest::Data::IncomingStreamStats.new(response.parsed_response)
    end
    # rubocop:enable Metrics/LineLength
  end
end
