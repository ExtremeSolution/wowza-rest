require 'wowza_rest/api'
require 'wowza_rest/connection'

module WowzaRest
  class Client
    include WowzaRest::API

    attr_accessor :host, :port, :username, :password, :server_name,
                  :api_version, :vhost
    attr_reader :connection

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      @connection = WowzaRest::Connection.new(base_uri, @username, @password)
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

    def base_uri
      "#{host}:#{port}/#{api_version}/servers/#{server_name}/vhosts/#{vhost}"
    end
  end
end
