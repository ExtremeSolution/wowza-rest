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
      subject(:instances) { client.instances('app_name') }
      it 'returns an array' do
        expect(instances).to be_an(Array)
      end

      it 'returns and array of WowzaRest::Data::Instance' do
        expect(instances.first)
          .to be_instance_of WowzaRest::Data::Instance
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
      it 'returns _definst_ instance',
         vcr: { cassette_name: 'instance_definst_found' } do
        response = client.get_instance('app_name')
        expect(response.name).to eq('_definst_')
      end
    end

    context 'when providing an instance name' do
      it 'returns an instance with given instance name',
         vcr: { cassette_name: 'instance_found' } do
        response = client.get_instance('app_name', 'instance_name')
        expect(response.name).to eq('instance_name')
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
      subject(:instance) do
        client.get_instance(
          'app_name', 'instance_name'
        )
      end

      it 'returns WowzaRest::Data::Instance instance',
         vcr: { cassette_name: 'instance_found' } do
        expect(instance).to be_instance_of WowzaRest::Data::Instance
      end

      it 'returns the requested instance hash',
         vcr: { cassette_name: 'instance_found' } do
        expect(instance.name).to eq('instance_name')
      end
    end
  end
  # rubocop:disable Metrics/LineLength
  describe '#get_incoming_stream_stats' do
    let(:endpoint) do
      "#{client.base_uri}/applications/app_name/instances/_definst_/incomingstreams/stream_name/monitoring/current"
    end

    context 'when not providing an instance_name' do
      # before do
      #   stub_request(:get, endpoint)
      # end

      it 'fetches stream stats for _definst_ instance',
         vcr: { cassette_name: 'incoming_streams_stat_definst_found' } do
        response = client.get_incoming_stream_stats(
          'app_name', 'stream_name'
        )
        expect(response.application_instance).to eq('_definst_')
      end
    end

    context 'when application name given does not exist' do
      it 'returns nil',
         vcr: { cassette_name: 'incoming_streams_stat_not_existed_app' } do
        response = client.get_incoming_stream_stats(
          'not_existed_app', 'stream_name'
        )
        expect(response).to be_nil
      end
    end

    context 'when it successfull fetches the stats' do
      it 'returns an IncomingStreamStatsa stats instance',
         vcr: { cassette_name: 'incoming_streams_stat_found' } do
        response = client.get_incoming_stream_stats(
          'app_name', 'stream_name'
        )
        expect(response).to be_instance_of WowzaRest::Data::IncomingStreamStats
      end
    end
  end
  # rubocop:enable Metrics/LineLength
end
