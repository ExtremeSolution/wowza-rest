require_relative 'base'

module WowzaRest
  module Data
    class Instance < Base
      OBJECT_ATTRS = %i[incoming_streams outgoing_streams
                        recorders stream_groups].freeze
      attr_reader *OBJECT_ATTRS

      def initialize(attrs = {})
        @incoming_streams = map_array_objects(attrs.delete('incomingStreams'), IncomingStream)
        @outgoing_streams = map_array_objects(attrs.delete('outgoingStreams'), OutgoingStream)
        @recorders = map_array_objects(attrs.delete('recorders'), Recorder)
        @stream_groups = map_array_objects(attrs.delete('streamGroups'), StreamGroup)
        super(attrs)
      end

      class IncomingStream < Base; end
      class OutgoingStream < Base; end
      class Recorder < Base; end
      class StreamGroup < Base; end
    end
  end
end
