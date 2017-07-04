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
  end
end
