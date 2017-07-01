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
  end
end
