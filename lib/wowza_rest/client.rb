require 'wowza_rest/api'
require 'wowza_rest/connection'
require 'wowza_rest/errors'

module WowzaRest
  class Client
    include WowzaRest::API
    include WowzaRest::Errors

    attr_accessor :host, :port, :username, :password, :server_name,
                  :api_version, :vhost
    attr_reader :connection

    def initialize(options = {})
      check_required_attrs(options)
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      @connection = WowzaRest::Connection.new(base_uri, @username, @password)
    end

    def server_status
      connection.class.base_uri server_path.to_s
      begin
        connection.request(:get, '/status').parsed_response
      rescue
        nil
      end
    end

    def server_name
      @server_name || '_defaultServer_'
    end

    def api_version
      @api_version || 'v2'
    end

    def vhost
      @vhost || '_defaultVHost_'
    end

    def server_path
      "#{host}:#{port}/#{api_version}/servers/#{server_name}"
    end

    def base_uri
      "#{server_path}/vhosts/#{vhost}"
    end

    private

    def check_required_attrs(options)
      required_attrs = %i[host port username password]
      missing_attrs = []
      required_attrs.each do |attr|
        missing_attrs << attr unless options.include? attr
      end

      return if missing_attrs.empty?
      raise WowzaRest::Errors::MissingRequiredKeys,
            "{ #{missing_attrs.join(' | ')} } missing"
    end
  end
end
