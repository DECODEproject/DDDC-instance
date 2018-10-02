# frozen_string_literal: true

module Decidim
  module Petitions
    class PetitionPresenter < SimpleDelegator
      include Rails.application.routes.mounted_helpers
      include ActionView::Helpers::UrlHelper
    end
  end
end
