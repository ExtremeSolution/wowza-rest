require 'spec_helper'

RSpec.describe WowzaRest::Applications do
  let(:client) do
    WowzaRest::Client.new(host: '127.0.0.1',
                          port: '8087',
                          username: ENV.fetch('WOWZA_USERNAME'),
                          password: ENV.fetch('WOWZA_PASSWORD'))
  end

  describe '#applications' do
    it 'fetches all applications', vcr: { cassette_name: 'all_applications' } do
      applications = client.applications
      expect(applications['applications']).not_to be_nil
    end
  end
end
