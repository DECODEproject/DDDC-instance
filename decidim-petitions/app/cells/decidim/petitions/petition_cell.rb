# frozen_string_literal: true

require "cell/partial"

module Decidim
  module Petitions
    class PetitionCell < Decidim::ViewModel
      include Cell::ViewModel::Partial
      include PetitionCellsHelper

      def show
        cell card_size, model, options
      end

      private

      def card_size
        "decidim/petitions/petition_m"
      end
    end
  end
end
