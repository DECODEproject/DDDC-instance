# frozen_string_literal: true

module Decidim
  module Dpetitions
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          # The public part needs to be implemented yet
          return permission_action if permission_action.scope != :admin
          return permission_action if permission_action.subject != :dpetition

          case permission_action.action
          when :create, :read
            allow!
          when :update, :delete
            toggle_allow(dpetition && dpetition.official?)
          end

          permission_action
        end

        private

        def dpetition
          @dpetition ||= context.fetch(:dpetition, nil)
        end
      end
    end
  end
end
