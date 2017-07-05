require 'spec_helper'

RSpec.describe WowzaRest::Publishers do
  let(:client) do
    WowzaRest::Client.new(host: '127.0.0.1',
                          port: '8087',
                          username: ENV['WOWZA_USERNAME'],
                          password: ENV['WOWZA_PASSWORD'])
  end

  describe '#create_publisher' do
    context 'when successfully creates the publisher' do
      it 'returns true',
         vcr: { cassette_name: 'create_publisher_success' } do
        response = client.create_publisher('name', 'password')
        expect(response).to be true
      end
    end

    context 'when the publisher name is already exists' do
      it 'returns false',
         vcr: { cassette_name: 'create_publisher_name_exists' } do
        response = client.create_publisher('name', 'password')
        expect(response).to be false
      end
    end
  end
end
