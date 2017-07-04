require 'wowza_rest/applications'
require 'wowza_rest/instances'

module WowzaRest
  module API
    # include all api modules here
    include WowzaRest::Applications
    include WowzaRest::Instances
  end
end
