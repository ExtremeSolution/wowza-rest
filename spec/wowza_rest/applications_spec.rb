require 'spec_helper'

RSpec.describe WowzaRest::Applications do
  let(:client) do
    WowzaRest::Client.new(host: '127.0.0.1',
                          port: '8087',
                          username: ENV['WOWZA_USERNAME'],
                          password: ENV['WOWZA_PASSWORD'])
  end

  let(:wrong_client) do
    WowzaRest::Client.new(host: '127.0.0.1',
                          port: '8087',
                          username: 'username',
                          password: 'wrongpassword')
  end

  describe '#applications' do
    it 'fetches all applications', vcr: { cassette_name: 'all_applications' } do
      applications = client.applications
      expect(applications['applications']).not_to be_nil
    end

    it 'responds with 401 when using incorrect creds',
       vcr: { cassette_name: 'all_applications_unauthrized' } do
      response = wrong_client.applications
      expect(response['code']).to eq('401')
    end
  end
end
