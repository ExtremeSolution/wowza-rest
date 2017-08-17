require_relative 'base'

module WowzaRest
  module Data
    class SMIL < Base
      attr_reader :smil_streams

      def initialize(attrs = {})
        keys_reader :smil_streams
        @smil_streams = wrap_array_objects(
          attrs.delete('smilStreams'), SMILStream
        )
        super(attrs)
      end

      class SMILStream < Base; end      
    end
  end
end
