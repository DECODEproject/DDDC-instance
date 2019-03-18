# frozen_string_literal: true

require "decidim/petitions/decode/connector"

module Decidim
  module Petitions
    module Admin
      class ActivatePetition < Rectify::Command
        def initialize(petition)
          @petition = petition
        end

        def call
          activate_petition
          setup_decode_services
          broadcast(:ok) if flash[:error] == nil
        end

        private

        attr_reader :petition

        def activate_petition
          petition.update! state: "opened", open: true
        end

        def add_error msg
          if flash[:error] == nil
            flash[:error] = msg
          else
            flash[:error] << "\r" + msg
          end
        end

        def check_for_errors status_code, component
          unless status_code == 200
            add_error(t(".errors.#{component}", status_code: status_code))
          end
        end

        def setup_decode_services
          connector = Decidim::Petitions::Decode::Connector.new(petition)
          setup_dddc_credentials connector
          setup_dddc_petitions connector
          setup_barcelona_now connector
        end

        def setup_dddc_credentials connector
          result = connector.setup_dddc_credentials
          check_for_errors result[:status_code], "credential_issuer"
        end

        def setup_dddc_petitions connector
          result = connector.setup_dddc_petitions
          petition.update(:petition_bearer, result[:bearer])
          check_for_errors result[:status_code], "petitions"
        end

        def setup_barcelona_now connector
          result = connector.setup_barcelona_now
          check_for_errors result[:status_code], "barcelona_now"
        end

      end
    end
  end
end
