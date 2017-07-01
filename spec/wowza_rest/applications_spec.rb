require 'spec_helper'

RSpec.describe WowzaRest::Applications do
  let(:client) do
    WowzaRest::Client.new(host: '127.0.0.1',
                          port: '8087',
                          username: ENV['WOWZA_USERNAME'],
                          password: ENV['WOWZA_PASSWORD'])
  end

  describe '#applications' do
    it 'fetches all applications', vcr: { cassette_name: 'all_applications' } do
      applications = client.applications
      expect(applications['applications']).not_to be_nil
    end
  end

  describe '#get_application' do
    context 'application is existed' do
      before do
        stub_request(:get, "#{client.base_uri}/applications/my_app")
          .to_return(status: 200, body: { name: 'my_app' }.to_json,
                     headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns the application object' do
        application = client.get_application('my_app')
        expect(application['name']).to eq('my_app')
      end
    end

    context 'application not exist' do
      before do
        stub_request(:get, "#{client.base_uri}/applications/not_existed_app")
          .to_return(status: 404,
                     body: { 'success' => false, 'code' => '404' }.to_json,
                     headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns nil if no application found' do
        application = client.get_application('not_existed_app')
        expect(application).to be_nil
      end
    end
  end
end
