# frozen_string_literal: true

module Decidim
  module Dpetitions
    # This cell renders the dpetition card for an instance of a Dpetition
    # the default size is the Medium Card (:m)
    class DpetitionCell < Decidim::ViewModel
      include DpetitionCellsHelper
      include Cell::ViewModel::Partial

      def show
        cell card_size, model
      end

      private

      def card_size
        "decidim/dpetitions/dpetition_m"
      end
    end
  end
end
