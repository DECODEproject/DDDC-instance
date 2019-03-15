# frozen_string_literal: true

require "decidim/petitions/decode/rest_api"

module Decidim
  module Petitions
    module Decode
      module Services
        class BarcelonaNow

          include RestApi

          def initialize login
            # login needs to be a hash with url
            # login = { url: "http://example.com" }
            @login = login
          end

          def create(credential_issuer_url: '', community_name: '', community_id: '', attribute_id: '')
            # Setup the Barcelona Now Dashboard API
            #
            begin
              response = RestClient.post(
                "#{@login[:url]}/community/create_encrypted",
                {
                  community_name: community_name,
                  community_id: community_id,
                  authorizable_attribute_id: attribute_id,
                  credential_issuer_endpoint_address: credential_issuer_url
                }.to_json,
                {content_type: :json, accept: :json}
              )
              status_code = 200
              logger_resp "Barcelona NOW Dashboard setup", response
            rescue RestClient::ExceptionWithResponse => err
              case err.http_code
              when 409
                logger "Barcelona Now FAILED! 409 conflict on Credential Issuer"
                status_code = 409
              else
                logger "Barcelona Now FAILED!"
                status_code = 500
              end
            end
            return { response: response, status_code: status_code }

          end

        end
      end
    end
  end
end
