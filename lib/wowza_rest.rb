require 'wowza_rest/version'
require 'wowza_rest/client'
require 'wowza_rest/core_ext/string/inflections'
require 'json'

module WowzaRest
  String.include WowzaRest::CoreExt::String::Inflections
end
