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

  context 'when it has an invalid username/password' do
    it 'responds with 401',
       vcr: { cassette_name: 'all_applications_unauthrized' } do
      response = wrong_client.applications
      expect(response['code']).to eq('401')
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
end
