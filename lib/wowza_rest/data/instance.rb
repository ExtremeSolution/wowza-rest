require_relative 'base'

module WowzaRest
  module Data
    class Instance < Base
      attr_reader :incoming_streams, :outgoing_streams,
                  :recorders, :stream_groups

      # rubocop:disable Metrics/MethodLength
      def initialize(attrs = {})
        @incoming_streams = wrap_array_objects(
          attrs.delete('incomingStreams'), IncomingStream
        )
        @outgoing_streams = wrap_array_objects(
          attrs.delete('outgoingStreams'), OutgoingStream
        )
        @recorders = wrap_array_objects(
          attrs.delete('recorders'), Recorder
        )
        @stream_groups = wrap_array_objects(
          attrs.delete('streamGroups'), StreamGroup
        )
        super(attrs)
      end
      # rubocop:enable Metrics/MethodLength

      class IncomingStream < Base; end
      class OutgoingStream < Base; end
      class Recorder < Base; end
      class StreamGroup < Base; end
    end
  end
end
