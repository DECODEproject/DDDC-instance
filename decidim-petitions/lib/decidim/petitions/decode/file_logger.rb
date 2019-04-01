# frozen_string_literal: true
#

module Decidim
  module Petitions
    module Decode
      module FileLogger

        def decode_logger
          @@decode_logger ||= Logger.new("#{Rails.root}/log/decode.log")
        end

        def logger message
          # Log with Rails.logger or just to stdout for Heroku
          #
          if ENV["RAILS_LOG_TO_STDOUT"].present?
            Rails.logger.info("DDDC-API -> #{message}")
          else
            decode_logger.info(message)
          end
        end

        def logger_resp(message, resp)
          # Log rest-client responses
          #
          logger("-" * 80)
          logger(message + " - response")
          logger "STATUS CODE => #{resp.code}"
          logger "BODY        => #{resp.body}"
          logger "HEADERS     => #{resp.headers}"
          logger("*" * 80)
        end

      end
    end
  end
end
