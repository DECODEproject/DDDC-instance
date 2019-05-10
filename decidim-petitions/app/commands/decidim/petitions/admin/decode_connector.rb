# frozen_string_literal: true

require "decidim/petitions/decode/connector"

module Decidim
  module Petitions
    module Admin
      class DecodeConnector < Rectify::Command
        def initialize(petition, command)
          @petition = petition
          @command = command
        end

        def call
          decode_command
          if flash[:error] == nil and flash[:warning] == nil
            broadcast(:ok)
          end
        end

        private

        attr_reader :petition

        def assert_count connector
          response = connector.assert_count_dddc_petitions
          api_result = connector.count_dddc_petitions
          flash[:info] = "
          Zenroom response = #{response} |||
          Petitions API Count = #{api_result[:response]}  |||
          Results = #{response == api_result[:response]}
          "
          result = { status_code: 200 }
        end 

        def get_and_show_response connector
          result = connector.get_dddc_petitions
          if result[:status_code] == 200
            flash[:info] = result[:response].body.as_json
          end
          result
        end

        def count_and_update_votes connector
          result = connector.count_dddc_petitions
          votes = JSON.parse(result[:response])["result"]
          petition.update_attribute(:votes, votes)
          result
        end

        def flash_decode_result status_code
          unless status_code == 200
            case status_code
            when 409
              # Status Code 409 is Conflict, as in "there's already that content on the API"
              flash[:warning] = t(".duplicated.#{@command}", status_code: status_code)
            else
              flash[:error] = t(".errors.#{@command}", status_code: status_code)
            end
          end
        end

        def decode_command
          # Wrapper for decode commands
          # Every command corresponds with an action on a DECODE service
          # It should always responds with a { status_code: XX } at least
          # Could also have { status_code: XX, response: "YYY" }
          #
          connector = Decidim::Petitions::Decode::Connector.new(petition, current_component)
          result = case @command
          when "credential_issuer"
            connector.setup_dddc_credentials
          when "barcelona_now_dashboard"
            connector.setup_barcelona_now
          when "petitions"
            connector.setup_dddc_petitions
          when "get"
            get_and_show_response(connector)
          when "tally"
            connector.tally_dddc_petitions
          when "count"
            count_and_update_votes(connector)
          when "assert_count"
            result = assert_count(connector) 
          end
          flash_decode_result(result[:status_code])
        end
      end
    end
  end
end
