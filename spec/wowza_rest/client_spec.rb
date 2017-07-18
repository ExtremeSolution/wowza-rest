require 'spec_helper'

RSpec.describe WowzaRest::Client do
  let(:client) do
    described_class.new(host: '127.0.0.1', port: '8087',
                        username: ENV['WOWZA_USERNAME'],
                        password: ENV['WOWZA_PASSWORD'])
  end

  let(:wrong_client) do
    described_class.new(host: '127.0.0.1', port: '8087',
                        username: 'username', password: 'wrongpassword')
  end

  context 'when a new object is instantiated' do
    it 'has a default server name' do
      expect(client.server_name).to eq '_defaultServer_'
    end

    it 'has a default api version' do
      expect(client.api_version).to eq 'v2'
    end

    it 'has a default vhost' do
      expect(client.vhost).to eq '_defaultVHost_'
    end

    it 'has a valid base uri' do
      expect(client.base_uri).to(
        eq '127.0.0.1:8087/v2/servers/_defaultServer_/vhosts/_defaultVHost_'
      )
    end

    it 'has a valid connection object' do
      expect(client.connection).to be_an_instance_of(WowzaRest::Connection)
    end
  end

  context 'when creating a new object' do
    context 'when host is missing' do
      it 'raises MissingRequiredKeys error' do
        expect do
          described_class
            .new(port: '8087', username: 'username', password: 'pass')
        end
          .to raise_error WowzaRest::Errors::MissingRequiredKeys
      end
    end

    context 'when port is missing' do
      it 'raises MissingRequiredKeys error' do
        expect do
          described_class
            .new(host: 'host', username: 'username', password: 'pass')
        end
          .to raise_error WowzaRest::Errors::MissingRequiredKeys
      end
    end

    context 'when username is missing' do
      it 'raises MissingRequiredKeys error' do
        expect do
          described_class
            .new(host: 'host', port: '8087', password: 'pass')
        end
          .to raise_error WowzaRest::Errors::MissingRequiredKeys
      end
    end

    context 'when password is missing' do
      it 'raises MissingRequiredKeys error' do
        expect do
          described_class
            .new(host: 'host', port: '8087', username: 'username')
        end
          .to raise_error WowzaRest::Errors::MissingRequiredKeys
      end
    end
  end

  describe '#server_status' do
    context 'when server is up' do
      it 'returns WowzaRest::Data::ServerStatus instance',
         vcr: { cassette_name: 'server_up_status' } do
        response = client.server_status
        expect(response).to be_an_instance_of(WowzaRest::Data::ServerStatus)
      end

      context 'when using wrong creds',
              vcr: { cassette_name: 'server_up_status_unauthorized' } do
        it 'returns WowzaRest::Data::ServerStatus with code 401' do
          response = wrong_client.server_status
          expect(response.code).to eq('401')
        end
      end
    end

    context 'when server is down' do
      before do
        allow(client.connection)
          .to receive(:request).and_raise(Errno::ECONNREFUSED)
      end

      it 'returns nil' do
        response = client.server_status
        expect(response).to be_nil
      end
    end

    context 'when client executes this request' do
      it 'has the same old base uri in the connection object',
         vcr: { cassette_name: 'server_up_status' } do
        client.server_status
        expect(client.connection.class.base_uri)
          .to eq(HTTParty.normalize_base_uri(client.base_uri))
      end
    end
  end
end
