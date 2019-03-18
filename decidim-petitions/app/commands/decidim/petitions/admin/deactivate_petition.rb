# frozen_string_literal: true

require "decidim/petitions/decode/connector"

module Decidim
  module Petitions
    module Admin
      class DeactivatePetition < Rectify::Command
        def initialize(petition)
          @petition = petition
        end

        def call
          deactivate_petition
          close_dddc_petitions
          broadcast(:ok) if flash[:error] == nil
        end

        private

        attr_reader :petition

        def close_dddc_petitions
          connector = Decidim::Petitions::Decode::Connector.new(petition)
          result = connector.close_dddc_petitions
          unless result[:status_code] == 200
            add_error(t(".errors.petitions", status_code: result[:status_code]))
          end
        end

        def deactivate_petition
          petition.update! state: "closed", open: false
        end
      end
    end
  end
end
