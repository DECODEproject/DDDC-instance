# frozen_string_literal: true

module Decidim
  module Dpetitions
    class SettingsChangeJob < ApplicationJob
      def perform(component_id, previous_settings, current_settings)
        return if unchanged?(previous_settings, current_settings)

        component = Decidim::Component.find(component_id)

        if dpetition_creation_enabled?(previous_settings, current_settings)
          event = "decidim.events.dpetitions.creation_enabled"
          event_class = Decidim::Dpetitions::CreationEnabledEvent
        elsif dpetition_creation_disabled?(previous_settings, current_settings)
          event = "decidim.events.dpetitions.creation_disabled"
          event_class = Decidim::Dpetitions::CreationDisabledEvent
        end

        Decidim::EventsManager.publish(
          event: event,
          event_class: event_class,
          resource: component,
          recipient_ids: component.participatory_space.followers.pluck(:id)
        )
      end

      private

      def unchanged?(previous_settings, current_settings)
        current_settings[:creation_enabled] == previous_settings[:creation_enabled]
      end

      def dpetition_creation_enabled?(previous_settings, current_settings)
        current_settings[:creation_enabled] == true &&
          previous_settings[:creation_enabled] == false
      end

      def dpetition_creation_disabled?(previous_settings, current_settings)
        current_settings[:creation_enabled] == false &&
          previous_settings[:creation_enabled] == true
      end
    end
  end
end
