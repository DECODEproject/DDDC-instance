# frozen_string_literal: true

module Decidim
  module Petitions
    class PetitionCell < Decidim::ModelView
      include Cell::ViewModel::Partial

      def show
        cell card_size, model, options
      end

      private

      def card_size
        "decidim/petitions/petition_m"
      end

      def current_component
        model.component
      end

      def current_participatory_space
        model.component.participatory_space
      end
    end
  end
end
