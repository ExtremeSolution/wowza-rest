require_relative 'base'

module WowzaRest
  module Data
    class Application < Base
      OBJECT_ATTRS = %i[security_config stream_config dvr_config
                        drm_config transcoder_config modules].freeze

      attr_reader *OBJECT_ATTRS

      def initialize(attrs = {})
        initialize_object_attrs(attrs)
        super(attrs)
      end

      class TranscoderConfig < Base
        attr_reader :templates
        def initialize(attrs = {})
          @templates = map_array_objects(attrs.delete('templates')['templates'], Template)
          super(attrs)
        end

        class Template < Base; end
      end

      class SecurityConfig < Base; end
      class StreamConfig < Base; end
      class DVRConfig < Base; end
      class DRMConfig < Base; end
      class Module < Base; end

      private

      def initialize_object_attrs(attrs)
        @security_config = SecurityConfig.new(attrs.delete('securityConfig'))
        @stream_config = StreamConfig.new(attrs.delete('streamConfig'))
        @dvr_config = DVRConfig.new(attrs.delete('dvrConfig'))
        @drm_config = DRMConfig.new(attrs.delete('drmConfig'))
        @transcoder_config = TranscoderConfig.new(attrs.delete('transcoderConfig'))
        @modules = map_array_objects(attrs.delete('modules')['moduleList'], Module)
      end
    end
  end
end
