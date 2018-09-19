# frozen_string_literal: true

module Decidim
  module Dpetitions
    module Admin
      # This controller allows an admin to manage dpetitions from a Participatory Space
      class DpetitionsController < Decidim::Dpetitions::Admin::ApplicationController
        helper_method :dpetitions

        def index
          enforce_permission_to :read, :dpetition
        end

        def new
          enforce_permission_to :create, :dpetition

          @form = form(Decidim::Dpetitions::Admin::DpetitionForm).instance
        end

        def create
          enforce_permission_to :create, :dpetition

          @form = form(Decidim::Dpetitions::Admin::DpetitionForm).from_params(params, current_component: current_component)

          CreateDpetition.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("dpetitions.create.success", scope: "decidim.dpetitions.admin")
              redirect_to dpetitions_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("dpetitions.create.invalid", scope: "decidim.dpetitions.admin")
              render action: "new"
            end
          end
        end

        def edit
          enforce_permission_to :update, :dpetition, dpetition: dpetition

          @form = form(DpetitionForm).from_model(dpetition)
        end

        def update
          enforce_permission_to :update, :dpetition, dpetition: dpetition

          @form = form(DpetitionForm).from_params(params, current_component: current_component)

          UpdateDpetition.call(@form, dpetition) do
            on(:ok) do
              flash[:notice] = I18n.t("dpetitions.update.success", scope: "decidim.dpetitions.admin")
              redirect_to dpetitions_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("dpetitions.update.invalid", scope: "decidim.dpetitions.admin")
              render action: "edit"
            end
          end
        end

        def destroy
          enforce_permission_to :delete, :dpetition, dpetition: dpetition

          dpetition.destroy!

          flash[:notice] = I18n.t("dpetitions.destroy.success", scope: "decidim.dpetitions.admin")

          redirect_to dpetitions_path
        end

        private

        def dpetitions
          @dpetitions ||= Dpetition.where(component: current_component)
        end

        def dpetition
          @dpetition ||= dpetitions.find(params[:id])
        end
      end
    end
  end
end
