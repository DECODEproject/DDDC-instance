# frozen_string_literal: true

module Decidim
  module Petitions
    class PetitionMCell < Decidim::CardMCell
      include PetitionCellsHelper

      private

      def has_image?
        false
      end

      def body
        translated_attribute(present(model).summary)
      end

      def description
        html_truncate(decidim_sanitize(translated_attribute(present(model).summary)), length: 100)
      end

      def progress_bar_progress
        model.votes || 0
      end

      def progress_bar_total
        model.votes || 0
      end
    end
  end
end
