# frozen_string_literal: true

module Decidim
  module Dpetitions
    # Custom helpers for dpetitions cells.
    #
    module DpetitionCellsHelper
      include PaginateHelper
      include Decidim::Comments::CommentsHelper
    end
  end
end
