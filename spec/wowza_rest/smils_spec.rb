require 'spec_helper'

# rubocop:disable RSpec/FilePath
RSpec.describe WowzaRest::SMILs do
  # rubocop:enable RSpec/FilePath

  let(:client) do
    WowzaRest::Client.new(host: '127.0.0.1',
                          port: '8087',
                          username: ENV['WOWZA_USERNAME'],
                          password: ENV['WOWZA_PASSWORD'])
  end

  let(:smil_body) do
    {
      smilStreams: [{
        src: 'vid1.mp4',
        type: 'video'
      }, {
        src: 'vid2.mp4',
        type: 'video'
      }]
    }
  end

  let(:smil_body_update) do
    {
      smilStreams: [{
        src: 'vid3.mp4',
        type: 'video'
      }, {
        src: 'vid4.mp4',
        type: 'video'
      }]
    }
  end

  describe '#smils' do
    context 'when successfully fetch all smils' do
      subject(:smils) { client.smils }

      it 'returns an array',
         vcr: { cassette_name: 'all_smils' } do
        expect(smils).to be_an(Array)
      end

      it 'has WowzaRest::Data::SMIL elements',
         vcr: { cassette_name: 'all_smils' } do
        expect(smils.first)
          .to be_instance_of WowzaRest::Data::SMILShort
      end
    end

    context 'when fails to fetch the smils' do
      before do
        stub_request(:get, "#{client.base_uri}/smilfiles")
          .to_return(status: 401,
                     body: { 'success' => false, 'code' => '401' }.to_json,
                     headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns nil' do
        response = client.smils
        expect(response).to be_nil
      end
    end
  end

  describe '#get_smil' do
    context 'when smil is exists' do
      subject(:smil) { client.get_smil('smil_name') }

      it 'returns WowzaRest::Data::SMIL instance',
         vcr: { cassette_name: 'smil_found' } do
        expect(smil).to be_instance_of WowzaRest::Data::SMIL
      end

      it 'has the same name requested',
         vcr: { cassette_name: 'smil_found' } do
        expect(smil.name).to eq('smil_name')
      end
    end

    context 'when smil do not exist' do
      before do
        stub_request(:get, "#{client.base_uri}/smilfiles/unknown_smil")
          .to_return(status: 404,
                     body: { 'success' => false, 'code' => '404' }.to_json,
                     headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns nil if smil not found' do
        smil = client.get_smil('unknown_smil')
        expect(smil).to be_nil
      end
    end
  end

  describe '#create_smil' do
    context 'when smil_name is not a string' do
      it 'raises InvalidArgumentType error' do
        expect do
          client.update_smil(123, smil_body)
        end
          .to raise_error WowzaRest::Errors::InvalidArgumentType
      end
    end

    context 'when successfully created a SMIL' do
      it 'responds with success response',
         vcr: { cassette_name: 'smil_create_successful' } do
        response = client.create_smil('new_smil', smil_body)
        expect(response).to be true
      end
    end

    context 'when smil_body is a WowzaRest::Data::SMIL instance' do
      subject(:response) do
        client.create_smil('new_smil', WowzaRest::Data::SMIL.new)
      end

      it 'responds with success response',
         vcr: { cassette_name: 'smil_create_successful' } do
        expect(response).to be true
      end
    end

    context 'when SMIL name is already exist' do
      it 'responds with failure response',
         vcr: { cassette_name: 'smil_create_exists' } do
        response = client.create_smil('new_smil', smil_body)
        expect(response).to be false
      end
    end
  end

  describe '#update_smil' do
    context 'when smil_name is not a string' do
      it 'raises InvalidArgumentType error' do
        expect do
          client.update_smil(123, smil_body)
        end
          .to raise_error WowzaRest::Errors::InvalidArgumentType
      end
    end

    context 'when fields not a hash or WowzaRest::Data::SMIL instance' do
      it 'raises InvalidArgumentType error' do
        expect do
          client.update_smil('smil_name', 'invalid_value')
        end
          .to raise_error WowzaRest::Errors::InvalidArgumentType
      end
    end

    context 'when smil is updated' do
      it 'returns true',
         vcr: { cassette_name: 'smil_updated' } do
        response = client.update_smil('smil_name', smil_body_update)
        expect(response).to be true
      end
    end

    context 'when smil not exist' do
      it 'returns false',
         vcr: { cassette_name: 'smil_update_not_exist' } do
        response = client.update_smil('not_existed_app', smil_body_update)
        expect(response).to be false
      end
    end
  end

  describe '#delete_smil' do
    context 'when smil_name is not a string' do
      it 'raises InvalidArgumentType error' do
        expect do
          client.delete_smil(123)
        end
          .to raise_error WowzaRest::Errors::InvalidArgumentType
      end
    end

    context 'when SMIL is deleted successfully',
            vcr: { cassette_name: 'smil_deleted' } do
      it 'returns true' do
        response = client.delete_smil('smil_name')
        expect(response).to be true
      end
    end

    context 'when an error occurs',
            vcr: { cassette_name: 'smil_delete_error' } do
      it 'returns false' do
        response = client.delete_smil('smil_name')
        expect(response).to be false
      end
    end
  end
end
