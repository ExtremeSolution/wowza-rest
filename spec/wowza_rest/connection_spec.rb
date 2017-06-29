require 'spec_helper'

RSpec.describe WowzaRest::Connection do
  let(:connection) { WowzaRest::Connection.new('localhost', 'username', 'password') }

  describe '#request' do
    it 'calls the corresponding method passed in as the first parameter' do
      expect(connection).to receive(:request).with(:get, 'localhost').once.and_call_original
      expect(WowzaRest::Connection).to receive(:get).with('localhost', {}).once
      connection.request(:get, 'localhost')
    end
  end
end
