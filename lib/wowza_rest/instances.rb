module WowzaRest
  module Instances
    def instances(app_name)
      connection.request(
        :get, "/applications/#{app_name}/instances"
      )['instanceList']
    end

    def get_instance(app_name, instance_name = '_definst_')
      response = connection.request(
        :get, "/applications/#{app_name}/instances/#{instance_name}"
      )
      response.code == 200 ? response.parsed_response : nil
    end

    # rubocop:disable Metrics/LineLength
    def get_incoming_stream_stats(app_name, stream_name, instance_name = '_definst_')
      response = connection.request(
        :get, "/applications/#{app_name}/instances/#{instance_name}/incomingstreams/#{stream_name}/monitoring/current"
      )
      response.code == 200 ? response.parsed_response : nil
    end
    # rubocop:enable Metrics/LineLength
  end
end
