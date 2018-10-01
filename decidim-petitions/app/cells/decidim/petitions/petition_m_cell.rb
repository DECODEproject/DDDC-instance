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
        truncate(decidim_sanitize(translated_attribute(present(model).summary)), length: 100)
      end
    end
  end
end
