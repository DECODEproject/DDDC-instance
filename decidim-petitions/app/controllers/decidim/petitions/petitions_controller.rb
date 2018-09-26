# frozen_string_literal: true

require_dependency "decidim/petitions/application_controller"

module Decidim
  module Petitions
    class PetitionsController < ApplicationController
      def index
        @petitions = Petition.where(component: current_component)
      end

      def show; end

      private

    end
  end
end
