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
            petition.update_attribute(:petition_bearer, result[:bearer])
          when "tally"
            connector.tally_dddc_petitions
          when "count"
            connector.count_dddc_petitions
          when "recount"
            connector.recount_dddc_petitions
          end
          unless result[:status_code] == 200
            flash[:error] = t(".errors.decode.#{@command}", status_code: result[:status_code])
          end
        end
      end
    end
  end
end
