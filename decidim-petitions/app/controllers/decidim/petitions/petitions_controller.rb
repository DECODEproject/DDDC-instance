# frozen_string_literal: true

require_dependency "decidim/petitions/application_controller"

module Decidim
  module Petitions
    class PetitionsController < ApplicationController
      helper Decidim::ApplicationHelper
      helper_method :petitions, :petition, :paginate_petitions

      def index; end

      def show; end

      private

      def paginate_petitions
        @paginate_petitions ||= petitions.page(params[:page]).per(4)
      end

      def petitions
        @petitions ||= Petition.where(component: current_component)
      end

      def petition
        @petition ||= petitions.find(params[:id])
      end
    end
  end
end
