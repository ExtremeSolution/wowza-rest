require_relative 'base'

module WowzaRest
  module Data
    class IncomingStreamStats < Base
      attr_reader :connection_count

      def initialize(attrs = {})
        @connection_count = ConnectionCount.new(attrs.delete('connectionCount'))
        super(attrs)
      end

      class ConnectionCount < Base; end
    end
  end
end
