require 'spec_helper'

RSpec.describe WowzaRest::Connection do
  let(:connection) do
    described_class.new('localhost', 'username', 'password')
  end

  describe '#request' do
    it 'responds' do
      allow(connection).to receive(:request).with(:method_name, 'uri')
      connection.request(:method_name, 'uri')
      expect(connection).to have_received(:request)
    end

    it 'perform a request' do
      stub_request(:get, 'localhost/path')
      response = connection.request(:get, '/path').response
      expect(response.code).to eq('200')
    end
  end
end
