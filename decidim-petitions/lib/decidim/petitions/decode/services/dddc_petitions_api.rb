# frozen_string_literal: true
#
require "decidim/petitions/decode/rest_api"

module Decidim
  module Petitions
    module Decode
      module Services
        class DDDCPetitionsAPI
          # Integration with https://github.com/DECODEproject/dddc-petition-api

          include RestApi

          def initialize login
            # login needs to be a hash with url, username and password
            # login = { url: "http://example.com", username: "demo", password: "demo"}
            @login = login
          end

          def create(petition_id: '', credential_issuer_url: '')
            # Creates the petition
            #
            bearer = get_bearer( url: @login[:url], username: @login[:username], password: @login[:password])
            params = { petition_id: petition_id, credential_issuer_url: credential_issuer_url }
            wrapper(http_method: :post, http_path: "#{@login[:url]}/petitions/", bearer: bearer, params: params)
          end

          def tally(bearer: '', petition_id: '')
            # Tally the petition
            #
            wrapper(http_method: :post, http_path: "#{@login[:url]}/petitions/#{petition_id}/tally", bearer: bearer)
          end

          def count(bearer: '', petition_id: '')
            # Count the petition
            #
            wrapper(http_method: :post, http_path: "#{@login[:url]}/petitions/#{petition_id}/count", bearer: bearer)
          end

          def get(bearer: '', petition_id: '')
            # Get the petition with extended information
            #
            wrapper(http_method: :get, http_path: "#{@login[:url]}/petitions/#{petition_id}?expand=true")
          end

        end
      end
    end
  end
end
