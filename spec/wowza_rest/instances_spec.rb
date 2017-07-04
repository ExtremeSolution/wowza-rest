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

  describe '#get_instance' do
    context 'when not providing an instance name' do
      before do
        stub_request(:get, 'applications/app_name/instances/_definst_')
      end

      it 'uses _definst_ as a default instance name' do
        client.get_instance('app_name')
        expect(WebMock)
          .to have_requested(
            :get, "#{client.base_uri}/applications/app_name/instances/_definst_"
          ).once
      end
    end

    context 'when providing an instance name' do
      before do
        stub_request(:get, 'applications/app_name/instances/instance_name')
      end

      it 'requests the given instance name' do
        client.get_instance('app_name', 'instance_name')
        expect(WebMock)
          .to have_requested(
            :get, "#{client.base_uri}/applications/app_name/instances/instance_name"
          ).once
      end
    end

    context 'when app_name not exists' do
      it 'returns nil',
         vcr: { cassette_name: 'instance_application_not_exists' } do
        response = client.get_instance('not_existed_app')
        expect(response).to be_nil
      end
    end

    context 'when a successfull request is made' do
      it 'returns the requested instance hash',
         vcr: { cassette_name: 'instance_found' } do
        response = client.get_instance('app_name', 'instance_name')
        expect(response['name']).to eq('instance_name')
      end
    end
  end
end
