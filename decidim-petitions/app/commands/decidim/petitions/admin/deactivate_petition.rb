# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class DeactivatePetition < Rectify::Command
        def initialize(petition)
          @petition = petition
        end

        def call
          deactivate_petition
          broadcast(:ok)
        end

        private

        attr_reader :petition

        def deactivate_petition
          petition.update! state: "closed", open: false
        end
      end
    end
  end
end
