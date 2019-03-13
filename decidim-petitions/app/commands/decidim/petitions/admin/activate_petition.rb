# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class ActivatePetition < Rectify::Command
        def initialize(petition)
          @petition = petition
        end

        def call
          activate_petition
          broadcast(:ok)
        end

        private

        attr_reader :petition

        def activate_petition
          petition.update! state: "opened", open: true
          connector = Decidim::Petitions::DecodeConnector.new(petition)
          connector.main
          #DecodeConnectorWorker.perform_async(petition.id)
        end
      end
    end
  end
end
