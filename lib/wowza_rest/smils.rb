require_relative 'data/smil'
require_relative 'data/smil_short'

module WowzaRest
    module SMILs
        def smils
            response = connection.request(
                :get, "/smilfiles"
            )
            return unless response.code == 200
            response.parsed_response['smilFiles']
                      .map { |e| WowzaRest::Data::SMILShort.new(e) }
        end
  
        def get_smil(smil_name)
            response = connection.request(:get, "/smilfiles/#{smil_name}")
            return unless response.code == 200
            WowzaRest::Data::SMIL.new(response.parsed_response)  
        end 

        def create_smil(smil_name, smil_body)
            unless smil_name.is_a?(String)
                raise WowzaRest::Errors::InvalidArgumentType,
                    "First argument expected to be String got #{smil_name.class}"
            end
            connection.request(:post, "/smilfiles/#{smil_name}", body: smil_body.to_json)            
        end

        def update_smil(smil_name, smil_body)
            connection.request(:put, "/smilfiles/#{smil_name}", body: smil_body.to_json)['success']
        end
    
        def delete_smil(smil_name)
            unless smil_name.is_a?(String)
                raise WowzaRest::Errors::InvalidArgumentType,
                      "First argument expected to be String got #{smil_name.class}"
            end
            connection.request(:delete, "/smilfiles/#{smil_name}")['success']
        end
      
    end
  end
  