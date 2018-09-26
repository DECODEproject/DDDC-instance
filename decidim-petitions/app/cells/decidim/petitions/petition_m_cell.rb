# frozen_string_literal: true

module Decidim
  module Petitions
    class PetitionMCell < Decidim::CardMCell
      private
      
      def has_image?
        false
      end

      def resource_path
        Decidim::Petitions::Engine.routes.url_helpers.petition_path(model)
      end
    end
  end
end
