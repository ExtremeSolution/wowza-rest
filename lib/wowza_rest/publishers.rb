module WowzaRest
  module Publishers
    def create_publisher(name, password)
      connection.request(
        :post, "/publishers/#{name}", body: { password: password }.to_json
      )['success']
    end
  end
end
