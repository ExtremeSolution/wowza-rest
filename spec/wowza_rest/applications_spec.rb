require 'spec_helper'

RSpec.describe WowzaRest::Applications do
  let(:client) do
    WowzaRest::Client.new(host: '127.0.0.1',
                          port: '8087',
                          username: ENV['WOWZA_USERNAME'],
                          password: ENV['WOWZA_PASSWORD'])
  end

  let(:application_body) do
    { appType: 'apptype', name: 'app_name' }
  end

  describe '#applications' do
    it 'fetches all applications', vcr: { cassette_name: 'all_applications' } do
      applications = client.applications
      expect(applications['applications']).not_to be_nil
    end
  end

  describe '#get_application' do
    context 'when application is existed' do
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

    context 'when application not exist' do
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

  describe '#create_application' do
    context 'when successfully create an app' do
      it 'responds with success response',
         vcr: { cassette_name: 'application_create_successful' } do
        response = client.create_application(application_body)
        expect(response['success']).to be true
      end
    end

    context 'when application id is already exist' do
      it 'responds with failure response',
         vcr: { cassette_name: 'application_create_exists' } do
        response = client.create_application(application_body)
        expect(response['success']).to be false
      end
    end

    context 'when has invalid confg' do
      it 'responds with failure response',
         vcr: { cassette_name: 'application_create_invalid_config' } do
        application_body['invalidKey'] = 'invalidValue'
        response = client.create_application(application_body)
        expect(response['success']).to be false
      end
    end

    context 'when missing required name attribute' do
      it 'raises MissingRequiredKeys exception' do
        no_name_app_body = application_body
        no_name_app_body.delete(:name)
        expect { client.create_application(no_name_app_body) }
          .to raise_error WowzaRest::Errors::MissingRequiredKeys
      end
    end
  end
end
