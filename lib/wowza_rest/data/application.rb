require_relative 'base'

module WowzaRest
  module Data
    class Application < Base
      attr_reader :security_config, :stream_config, :dvr_config,
                  :drm_config, :transcoder_config, :modules

      def initialize(attrs = {})
        keys_reader :securityConfig, :streamConfig, :dvrConfig,
                    :drmConfig, :transcoderConfig, :modules
        initialize_object_attrs(attrs || {})
        super(attrs)
      end

      def to_h
        super() do |k, arr|
          if k == :@modules
            {
              moduleList: objects_array_to_hash_array(arr)
            }
          else
            objects_array_to_hash_array(arr)
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
          if !attrs.nil? &&  attrs['templates']
            keys_reader :templates
            @templates = wrap_array_objects(
              attrs.delete('templates')['templates'], Template
            )
          end
          super(attrs)
        end

        def to_h
          super() do |k, arr|
            if k == :@templates
              {
                templates: objects_array_to_hash_array(arr)
              }
            else
              objects_array_to_hash_array(arr)
            end
          end
        end

        class Template < Base; end
      end

      private

      # rubocop:disable Metrics/MethodLength
      def initialize_object_attrs(attrs)
        if attrs['modules']
          @modules = wrap_array_objects(
            attrs.delete('modules')['moduleList'], Module
          )
        end
        @security_config = SecurityConfig.new(attrs.delete('securityConfig'))
        @stream_config = StreamConfig.new(attrs.delete('streamConfig'))
        @dvr_config = DVRConfig.new(attrs.delete('dvrConfig'))
        @drm_config = DRMConfig.new(attrs.delete('drmConfig'))
        @transcoder_config = TranscoderConfig.new(
          attrs.delete('transcoderConfig')
        )
      end
    end
  end
end
