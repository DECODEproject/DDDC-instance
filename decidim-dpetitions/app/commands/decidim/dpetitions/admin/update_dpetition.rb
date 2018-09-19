# frozen_string_literal: true

module Decidim
  module Dpetitions
    module Admin
      # This command is executed when the user changes a Dpetition from the admin
      # panel.
      class UpdateDpetition < Rectify::Command
        # Initializes a UpdateDpetition Command.
        #
        # form - The form from which to get the data.
        # dpetition - The current instance of the page to be updated.
        def initialize(form, dpetition)
          @form = form
          @dpetition = dpetition
        end

        # Updates the dpetition if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?

          update_dpetition
          broadcast(:ok)
        end

        private

        attr_reader :dpetition, :form

        def update_dpetition
          Decidim.traceability.update!(
            dpetition,
            form.current_user,
            category: form.category,
            title: form.title,
            description: form.description,
            information_updates: form.information_updates,
            instructions: form.instructions,
            end_time: form.end_time,
            start_time: form.start_time
          )
        end
      end
    end
  end
end
