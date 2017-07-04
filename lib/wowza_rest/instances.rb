module WowzaRest
  module Instances
    def instances(app_name)
      connection.request(
        :get, "/applications/#{app_name}/instances"
      )['instanceList']
    end
  end
end
