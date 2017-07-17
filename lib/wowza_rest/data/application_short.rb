require_relative 'base'

module WowzaRest
  module Data
    class ApplicationShort < Base
      def initialize(attrs)
        setup_attributes(attrs)
      end
    end
  end
end
