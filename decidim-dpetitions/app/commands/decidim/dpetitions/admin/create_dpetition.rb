# frozen_string_literal: true

module Decidim
  module Dpetitions
    module Admin
      # This command is executed when the user creates a Dpetition from the admin
      # panel.
      class CreateDpetition < Rectify::Command
        def initialize(form)
          @form = form
        end

        # Creates the dpetition if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            create_dpetition
            send_notification_to_space_followers
          end
          broadcast(:ok)
        end

        private

        attr_reader :dpetition, :form

        def create_dpetition
          @dpetition = Decidim.traceability.create!(
            Dpetition,
            form.current_user,
            category: form.category,
            title: form.title,
            description: form.description,
            information_updates: form.information_updates,
            instructions: form.instructions,
            end_time: form.end_time,
            start_time: form.start_time,
            component: form.current_component
          )
        end

        def send_notification_to_space_followers
          Decidim::EventsManager.publish(
            event: "decidim.events.dpetitions.dpetition_created",
            event_class: Decidim::Dpetitions::CreateDpetitionEvent,
            resource: dpetition,
            recipient_ids: form.current_component.participatory_space.followers.pluck(:id),
            extra: {
              type: "participatory_space"
            }
          )
        end
      end
    end
  end
end
