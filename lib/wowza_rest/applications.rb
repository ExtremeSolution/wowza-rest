module WowzaRest
  module Applications
    def applications
      connection.request(:get, '/applications').parsed_response
    end

    def get_application(app_name)
      connection.request(:get, "/applications/#{app_name}").parsed_response
    end
  end
end
