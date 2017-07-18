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

      def wrap_array_objects(arr, klass)
        arr.map { |obj| klass.new(obj) }
      end

      def hashize_array_objects(arr)
        arr.map do |obj|
          obj.is_a?(WowzaRest::Data::Base) ? obj.to_h : obj
        end
      end

      def to_h
        instance_variables.each_with_object({}) do |var, hash|
          if instance_variable_get(var).is_a?(WowzaRest::Data::Base)
            hash[var.to_s.delete('@').camelize.to_sym] = instance_variable_get(var).to_h
          elsif instance_variable_get(var).is_a?(Array)
            if block_given?
              hash[var.to_s.delete('@').camelize.to_sym] = yield(var, instance_variable_get(var))
            else
              hash[var.to_s.delete('@').camelize.to_sym] = hashize_array_objects(instance_variable_get(var))
            end
          else
            hash[var.to_s.delete('@').camelize.to_sym] = instance_variable_get(var)
          end
        end
      end
      alias to_hash to_h
    end
  end
end
