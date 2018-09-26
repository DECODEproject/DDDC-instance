# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class DestroyPetition < Rectify::Command
        def initialize(petition)
          @petition = petition
        end

        def call
          destroy_petition
          broadcast(:ok)
        end

        private

        attr_reader :petition

        def destroy_petition
          petition.destroy!
        end
      end
    end
  end
end
