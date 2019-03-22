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
          broadcast(:ok) if flash[:error] == nil
        end

        private

        attr_reader :petition

        def decode_command
          connector = Decidim::Petitions::Decode::Connector.new(petition)
          result = case @command
          when "credential_issuer"
            connector.setup_dddc_credentials
          when "barcelona_now_dashboard"
            connector.setup_barcelona_now
          when "petitions"
            connector.setup_dddc_petitions
          when "get"
            result = connector.get_dddc_petitions
            if result[:status_code] == 200
              flash[:info] = result[:response].body.as_json
            end
            result
          when "tally"
            connector.tally_dddc_petitions
          when "count"
            result = connector.count_dddc_petitions
            votes = JSON.parse(result[:response])["result"]
            petition.update_attribute(:votes, votes)
            result
          when "assert_count"
            response = connector.assert_count_dddc_petitions
            api_result = connector.count_dddc_petitions
            flash[:info] = "
            Zenroom response = #{response} |||
            Petitions API Count = #{api_result[:response]}  |||
            Results = #{response == api_result[:response]}
            "
            result = { status_code: 200 }
          end
          unless result[:status_code] == 200
            flash[:error] = t(".errors.decode.#{@command}", status_code: result[:status_code])
          end
        end
      end
    end
  end
end
