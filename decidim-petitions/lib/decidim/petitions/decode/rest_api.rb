# frozen_string_literal: true
#

module Decidim
  module Petitions
    module Decode
      module RestApi

        def get_bearer(url: '', username: '', password: '')
          # Gets DDDC's API bearer to have an Authorization
          # It's the same for the Credential Issuer and for the Petititons APIs
          #
          resp = RestClient.post(
            "#{url}/token",
            {grant_type: "", username: username, password: password}
          )
          logger_resp "Bearer", resp
          bearer = JSON.parse(resp.body)["access_token"]
          bearer
        end

        def logger_resp message, resp
          # Helper function to log rest-client responses
          #
          logger message + " - initializing"
          # TODO: log more data
          logger JSON.parse(resp.body)
          logger message + " - closing"
        end

        def logger message
          # Helper function to log with Rails.logger or just to stdout
          #
          if defined? Rails
            require 'logger'
            Rails.logger.info message
          else
            puts message
          end
        end

      end
    end
  end
end
