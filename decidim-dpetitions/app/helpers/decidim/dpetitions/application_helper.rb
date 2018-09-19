# frozen_string_literal: true

module Decidim
  module Dpetitions
    # Custom helpers, scoped to the dpetitions engine.
    #
    module ApplicationHelper
      include PaginateHelper
      include Decidim::Comments::CommentsHelper
    end
  end
end
