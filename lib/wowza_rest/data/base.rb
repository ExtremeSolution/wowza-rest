module WowzaRest
  module Data
    class Base
      def initialize(attrs = {})
        setup_attributes(attrs || {})
      end

      def setup_attributes(attrs)
        attrs.each do |k, v|
          define_attribute_getter(k.to_s.underscore)
          define_attribute_setter(k.to_s.underscore)
          define_key_getter(k.to_s)
          instance_variable_set("@#{k.to_s.underscore}", v)
        end
      end

      def define_attribute_getter(attr_name)
        define_singleton_method(attr_name.to_s) do
          instance_variable_get("@#{attr_name}")
        end
      end

      def define_attribute_setter(attr_name)
        define_singleton_method("#{attr_name}=") do |value|
          instance_variable_set("@#{attr_name}", value)
        end
      end

      def define_key_getter(key)
        define_singleton_method("#{key.underscore}_key") do
          key.to_s
        end
      end

      def keys_reader(*args)
        args.each do |arg|
          define_key_getter(arg.to_s)
        end
      end

      def wrap_array_objects(arr, klass)
        arr.map { |obj| klass.new(obj) } unless arr.nil?
      end

      def objects_array_to_hash_array(arr)
        return if arr.nil?
        arr.map do |obj|
          obj.is_a?(WowzaRest::Data::Base) ? obj.to_h : obj
        end
      end

      # rubocop:disable Metrics/MethodLength
      def to_h
        instance_variables.each_with_object({}) do |var, hash|
          value = instance_variable_get(var)
          hash[send("#{var.to_s.delete('@')}_key")] =
            if value.is_a?(WowzaRest::Data::Base)
              instance_variable_get(var).to_h
            elsif value.is_a?(Array)
              if block_given?
                yield(var, instance_variable_get(var))
              else
                objects_array_to_hash_array(instance_variable_get(var))
              end
            else
              instance_variable_get(var)
            end
        end
      end
      # rubocop:enable Metrics/MethodLength
      alias to_hash to_h

      def to_json
        to_h.to_json
      end

      def include?(attr_name)
        to_h.include?(attr_name.to_s)
      end
    end
  end
end
