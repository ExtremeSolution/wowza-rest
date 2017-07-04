require 'spec_helper'

RSpec.describe WowzaRest::Instances do
  let(:client) do
    WowzaRest::Client.new(host: '127.0.0.1',
                          port: '8087',
                          username: ENV['WOWZA_USERNAME'],
                          password: ENV['WOWZA_PASSWORD'])
  end

  describe '#instances' do
    context 'when the application exists',
            vcr: { cassette_name: 'all_instances' } do
      it 'returns a list of available instances' do
        instances = client.instances('app_name')
        expect(instances).not_to be_nil
      end
    end

    context 'when the application not exists' do
      before do
        stub_request(
          :get, "#{client.base_uri}/applications/not_existed_app/instances"
        )
          .to_return(status: 404,
                     body: { 'success' => false, 'code' => '404' }.to_json,
                     headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns nil' do
        instances = client.instances('not_existed_app')
        expect(instances).to be_nil
      end
    end
  end
end
