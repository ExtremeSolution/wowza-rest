require_relative 'base'

module WowzaRest
  module Data
    class Application < Base
      attr_reader :security_config, :stream_config, :dvr_config,
                  :drm_config, :transcoder_config, :modules

      def initialize(attrs = {})
        initialize_object_attrs(attrs)
        super(attrs)
      end

      def to_h
        super() do |k, arr|
          if k == :@modules
            {
              moduleList: hashize_array_objects(arr)
            }
          else
            hashize_array_objects(arr)
          end
        end
      end

      class SecurityConfig < Base; end
      class StreamConfig < Base; end
      class DVRConfig < Base; end
      class DRMConfig < Base; end
      class Module < Base; end

      class TranscoderConfig < Base
        attr_reader :templates
        def initialize(attrs = {})
          @templates = wrap_array_objects(
            attrs.delete('templates')['templates'], Template
          )
          super(attrs)
        end

        def to_h
          super() do |k, arr|
            if k == :@templates
              {
                templates: hashize_array_objects(arr)
              }
            else
              hashize_array_objects(arr)
            end
          end
        end

        class Template < Base; end
      end

      private

      def initialize_object_attrs(attrs)
        @security_config = SecurityConfig.new(attrs.delete('securityConfig'))
        @stream_config = StreamConfig.new(attrs.delete('streamConfig'))
        @dvr_config = DVRConfig.new(attrs.delete('dvrConfig'))
        @drm_config = DRMConfig.new(attrs.delete('drmConfig'))
        @transcoder_config = TranscoderConfig.new(
          attrs.delete('transcoderConfig')
        )
        @modules = wrap_array_objects(
          attrs.delete('modules')['moduleList'], Module
        )
      end
    end
  end
end
