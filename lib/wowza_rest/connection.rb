require 'httparty'

module WowzaRest
  class Connection
    include HTTParty

    def initialize(uri, username, password)
      self.class.base_uri(uri)
      self.class.digest_auth(username, password)
      self.class.headers('Accept' => 'application/json',
                         'Content-Type' => 'application/json')
    end

    def request(method, path, options = {}, &block)
      self.class.public_send(method, path, options, &block)
    end
  end
end
