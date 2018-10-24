# frozen_string_literal: true

module Decidim
  module Petitions
    class PetitionMCell < Decidim::CardMCell
      include PetitionCellsHelper

      property :state

      private

      def has_image?
        true
      end

      def has_state?
        true
      end

      def badge_name
       I18n.t(state, scope: "decidim.petitions.states")
      end

      def state_classes
        case state
        when "opened"
          ["success"]
        when "closed"
          ["warning"]
        else
          ["muted"]
        end
      end
        
      def body
        translated_attribute(present(model).summary)
      end

      def description
        html_truncate(decidim_sanitize(translated_attribute(present(model).summary)), length: 100)
      end

      def resource_image_path
        model.image.url
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
