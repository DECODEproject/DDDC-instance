# frozen_string_literal: true
#
require "decidim/petitions/decode/rest_api"

module Decidim
  module Petitions
    module Decode
      module Services
        class DDDCPetitionsAPI

          include RestApi

          def initialize login
            # login needs to be a hash with url, username and password
            # login = { url: "http://example.com", username: "demo", password: "demo"}
            @login = login
          end

          def create(petition_id: '', credential_issuer_url: '')
            # Setup the Petition's API
            #
            url = @login[:url]
            bearer = get_bearer(
              url: url,
              username: @login[:username],
              password: @login[:password]
            )
            begin
              response = RestClient.post(
                "#{url}/petitions/",
                {
                  petition_id: petition_id,
                  credential_issuer_url: credential_issuer_url
                }.to_json,
                {
                  authorization: "Bearer #{bearer}",
                  content_type: :json,
                  accept: :json
                }
              )
              status_code = 200
              logger_resp "Petitions API setup", response
            rescue RestClient::ExceptionWithResponse => err
              case err.http_code
              when 409
                logger "Petitions API FAILED! 409 conflict"
                status_code = 409
              else
                logger "Petitions API FAILED! 500 error"
                status_code = 500
              end
            end
            return { response: response, status_code: status_code, bearer: bearer }
          end

          def close(bearer: '', petition_id: '')
            # Close the petition on Petition's API
            #
            begin
              response = RestClient.post(
                "#{url}/petitions/#{petition_id}/tally",
                {},
                {
                  authorization: "Bearer #{bearer}",
                  content_type: :json,
                  accept: :json
                }
              )
              status_code = 200
              logger_resp "Petitions API closing tally", response
            rescue RestClient::ExceptionWithResponse => err
              case err.http_code
              when 409
                logger "Petitions API FAILED! 409 conflict"
                status_code = 409
              else
                logger "Petitions API FAILED! 500 error"
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
