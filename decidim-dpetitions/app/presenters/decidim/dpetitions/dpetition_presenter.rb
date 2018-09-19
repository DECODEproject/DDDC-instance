# frozen_string_literal: true

module Decidim
  module Dpetitions
    #
    # Decorator for dpetitions
    #
    class DpetitionPresenter < SimpleDelegator
      def author
        @author ||= if official?
                      Decidim::Dpetitions::OfficialAuthorPresenter.new
                    elsif user_group
                      Decidim::UserGroupPresenter.new(user_group)
                    else
                      Decidim::UserPresenter.new(super)
                    end
      end
    end
  end
end
