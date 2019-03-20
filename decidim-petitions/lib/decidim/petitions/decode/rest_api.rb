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

        def logger_resp(message, resp)
          # Log rest-client responses
          #
          logger("*" * 80)
          logger(message + " - initializing")
          logger resp.code
          logger resp.body
          logger resp.headers
          logger resp.request
          logger(message + " - closing")
          logger("*" * 80)
        end

        def logger message
          # Log with Rails.logger or just to stdout
          #
          Rails.logger.info(message)
        end

        def wrapper(http_method: :post, http_path: '', bearer: '', params: {})
          # Call a given method on a path for some params with a bearer
          # We also log a lot what's happening
          #
          begin
            case http_method
            when :post
              response = call_post(bearer, http_path, params)
              status_code = 200
              logger_resp "API setup", response
            when :get
              response = call_get(http_path)
              status_code = 200
              logger_resp "API setup", response            end
          rescue RestClient::ExceptionWithResponse => err
            status_code = error_logger(err)
          end
          return { response: response, status_code: status_code, bearer: bearer }
        end

        def call_post(bearer, http_path, params)
          # Accepts an optional bearer and make a POST request
          #
          if bearer.empty?
            headers = { content_type: :json, accept: :json }
          else
            headers = { authorization: "Bearer #{bearer}", content_type: :json, accept: :json }
          end
          logger http_path
          logger params
          logger headers
          response = RestClient.post(
            http_path,
            params.to_json,
            headers
          )
        end

        def call_get(http_path)
          # Accepts an optional bearer and make a POST request
          #
          headers = { content_type: :json, accept: :json }
          logger http_path
          logger headers
          response = RestClient.get(
            http_path,
            headers
          )
        end

        def error_logger err
          # Error logger for rest-client exceptions
          #
          case err.http_code
          when 409
            logger "FAILED! 409 conflict"
            status_code = 409
          when 501
            # When it's already defined, Barcelona Now API returns a 501
            # with an error message that the community already exists.
            # For consistency with the rest of the APIs we'll set it as a 409 status
            if err.response.to_s == "{\n  \"message\": \"community_id or attribute_id already exist\"\n}\n"
              logger "Barcelona Now FAILED! 409 conflict"
              status_code = 409
            else
              logger "Barcelona Now FAILED!"
              status_code = 500
            end
          else
            logger "FAILED! 500 error"
            status_code = 500
          end
        end

      end
    end
  end
end
