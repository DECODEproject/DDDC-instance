# frozen_string_literal: true

module Decidim
  module Dpetitions
    # This command is executed when the user creates a Dpetition from the public
    # views.
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
          send_notifications
        end
        broadcast(:ok, dpetition)
      end

      private

      attr_reader :dpetition, :form

      def organization
        @organization = form.current_component.organization
      end

      def i18n_field(field)
        organization.available_locales.inject({}) do |i18n, locale|
          i18n.update(locale => field)
        end
      end

      def create_dpetition
        @dpetition = Dpetition.create!(
          author: form.current_user,
          decidim_user_group_id: form.user_group_id,
          category: form.category,
          title: i18n_field(form.title),
          description: i18n_field(form.description),
          component: form.current_component
        )
      end

      def send_notifications
        send_notification(dpetition.author.followers.pluck(:id), :user)
        send_notification(dpetition.participatory_space.followers.pluck(:id), :participatory_space)
      end

      def send_notification(recipient_ids, type)
        Decidim::EventsManager.publish(
          event: "decidim.events.dpetitions.dpetition_created",
          event_class: Decidim::Dpetitions::CreateDpetitionEvent,
          resource: dpetition,
          recipient_ids: recipient_ids,
          extra: {
            type: type.to_s
          }
        )
      end
    end
  end
end
