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
    context 'when successfully fetch all applications' do
      subject(:applications) { client.applications }

      it 'returns an array',
         vcr: { cassette_name: 'all_applications' } do
        expect(applications).to be_an(Array)
      end

      it 'has WowzaRest::Data::Application elements',
         vcr: { cassette_name: 'all_applications' } do
        expect(applications.first).to be_instance_of WowzaRest::Data::ApplicationShort
      end
    end

    context 'when fails to fetch the applications' do
      before do
        stub_request(:get, "#{client.base_uri}/applications")
          .to_return(status: 401,
                     body: { 'success' => false, 'code' => '401' }.to_json,
                     headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns nil' do
        response = client.applications
        expect(response).to be_nil
      end
    end
  end

  describe '#get_application' do
    context 'when application is existed' do
      subject(:application) { client.get_application('my_app') }

      it 'returns WowzaRest::Data::Application instance',
         vcr: { cassette_name: 'application_found' } do
        expect(application).to be_instance_of WowzaRest::Data::Application
      end

      it 'has the same name requested',
         vcr: { cassette_name: 'application_found' } do
        expect(application.name).to eq('my_app')
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

    context 'when using default configs' do
      before do
        stub_request(:post, "#{client.base_uri}/applications")
        client.create_application(application_body)
      end

      it 'has httpCORSHeadersEnabled attribute in the request' do
        expect(WebMock)
          .to have_requested(:post, "#{client.base_uri}/applications")
          .with(body: hash_including(:httpCORSHeadersEnabled))
      end

      it 'has clientStreamWriteAccess attribute in the request' do
        expect(WebMock)
          .to have_requested(:post, "#{client.base_uri}/applications")
          .with(body: hash_including(:clientStreamWriteAccess))
      end

      it 'has securityConfig hash in the request' do
        expect(WebMock)
          .to have_requested(:post, "#{client.base_uri}/applications")
          .with(body: hash_including(:securityConfig))
      end

      it 'has streamConfig hash in the request' do
        expect(WebMock)
          .to have_requested(:post, "#{client.base_uri}/applications")
          .with(body: hash_including(:streamConfig))
      end

      it 'has modules hash in the request' do
        expect(WebMock)
          .to have_requested(:post, "#{client.base_uri}/applications")
          .with(body: hash_including(:modules))
      end
    end

    context 'when bypassing default_config options' do
      before do
        stub_request(:post, "#{client.base_uri}/applications")
        client.create_application(application_body, false)
      end

      it 'has the same configs that was given' do
        expect(WebMock)
          .to have_requested(:post, "#{client.base_uri}/applications")
          .with(body: application_body)
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

  describe '#update_application' do
    context 'when app_name is not a string' do
      it 'raises InvalidArgumentType error' do
        expect do
          client.update_application(123, field_to_be_updated: 'value')
        end
          .to raise_error WowzaRest::Errors::InvalidArgumentType
      end
    end

    context 'when fields is not a hash' do
      it 'raises InvalidArgumentType error' do
        expect do
          client.update_application('app_name', 'invalid_value')
        end
          .to raise_error WowzaRest::Errors::InvalidArgumentType
      end
    end

    context 'when application is updated' do
      it 'returns true',
         vcr: { cassette_name: 'application_updated' } do
        response = client.update_application('app_name', appType: 'VOD')
        expect(response).to be true
      end
    end

    context 'when application not exist' do
      it 'returns false',
         vcr: { cassette_name: 'application_update_not_exist' } do
        response = client.update_application('not_existed_app', appType: 'VOD')
        expect(response).to be false
      end
    end

    context 'when fields hash is empty' do
      it 'raises InvalidArgument error' do
        expect do
          client.update_application('not_existed_app', {})
        end
          .to raise_error WowzaRest::Errors::InvalidArgument
      end
    end
  end

  describe '#delete_application' do
    context 'when app_name is not a string' do
      it 'raises InvalidArgumentType error' do
        expect do
          client.delete_application(123)
        end
          .to raise_error WowzaRest::Errors::InvalidArgumentType
      end
    end

    context 'when application is deleted successfully',
            vcr: { cassette_name: 'application_deleted' } do
      it 'returns true' do
        response = client.delete_application('app_name')
        expect(response).to be true
      end
    end

    context 'when an error occurs',
            vcr: { cassette_name: 'application_delete_error' } do
      it 'returns false' do
        response = client.delete_application('app_name')
        expect(response).to be false
      end
    end
  end
end
