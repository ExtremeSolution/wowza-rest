module WowzaRest
  module Data
    class Base
      def initialize(attrs = {})
        setup_attributes(attrs)
      end

      def setup_attributes(attrs)
        attrs.each do |k, v|
          define_attribute_getter(k.underscore)
          define_attribute_setter(k.underscore)
          instance_variable_set("@#{k.underscore}", v)
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

      def map_array_objects(arr, klass)
        arr.map { |obj| klass.new(obj) }
      end
    end
  end
end
