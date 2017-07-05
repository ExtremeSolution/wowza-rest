require 'wowza_rest/applications'
require 'wowza_rest/instances'
require 'wowza_rest/publishers'

module WowzaRest
  module API
    # include all api modules here
    include WowzaRest::Applications
    include WowzaRest::Instances
    include WowzaRest::Publishers
  end
end
