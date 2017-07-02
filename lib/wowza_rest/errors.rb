module WowzaRest
  module Errors
    class MissingRequiredKeys < StandardError; end
    class InvalidArgumentType < StandardError; end
    class InvalidArgument < StandardError; end
  end
end
