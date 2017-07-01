module WowzaRest
  module Applications
    def applications
      connection.request(:get, '/applications').parsed_response
    end

    def get_application(app_name)
      response = connection.request(:get, "/applications/#{app_name}")
      response.response.code == '200' ? response.parsed_response : nil
    end
  end
end
