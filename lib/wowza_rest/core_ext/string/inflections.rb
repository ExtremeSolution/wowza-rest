module WowzaRest
  module CoreExt
    module String
      module Inflections
        # its mainly used when converting json attrs to getters/setters methods
        # wowza rest api responses sometimes have attributes that contains dots
        # and this causes problems when trying to convert it to a method
        # thats why i have to replace all dots with underscores
        def underscore
          gsub(/::/, '/')
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .tr('-', '_')
            .tr('.', '_')
            .downcase
        end

        def camelize
          tr('-', '_')
            .gsub(/\b[A-Z]+/, &:downcase)
            .gsub(/_(.)/, &:upcase)
            .tr('_', '')
        end
      end
    end
  end
end
