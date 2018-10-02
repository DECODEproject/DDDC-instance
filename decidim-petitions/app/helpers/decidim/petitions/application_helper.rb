# frozen_string_literal: true

module Decidim
  module Petitions
    # Custom helpers, scoped to the petitions engine.
    #
    module ApplicationHelper
      include PaginateHelper
      include SanitizeHelper
      include Decidim::Petitions::PetitionsHelper
    end
  end
end
