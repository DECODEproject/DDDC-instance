# frozen_string_literal: true

module Decidim
  module Dpetitions
    module AdminLog
      # This class holds the logic to present a `Decidim::Dpetition`
      # for the `AdminLog` log.
      #
      # Usage should be automatic and you shouldn't need to call this class
      # directly, but here's an example:
      #
      #    action_log = Decidim::ActionLog.last
      #    view_helpers # => this comes from the views
      #    DpetitionPresenter.new(action_log, view_helpers).present
      class DpetitionPresenter < Decidim::Log::BasePresenter
        private

        def diff_fields_mapping
          {
            description: :i18n,
            end_date: :date,
            information_updates: :i18n,
            instructions: :i18n,
            start_date: :date,
            title: :i18n
          }
        end

        def i18n_labels_scope
          "activemodel.attributes.dpetition"
        end

        def action_string
          case action
          when "create", "update"
            "decidim.dpetitions.admin_log.dpetition.#{action}"
          else
            super
          end
        end
      end
    end
  end
end
