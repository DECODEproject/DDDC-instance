# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class PetitionsController < Admin::ApplicationController
        def new
          enforce_permission_to :create, :petition
          @form = form(PetitionForm).instance
        end

        def create
          enforce_permission_to :create, :petition
          @form = form(PetitionForm).from_params(params, current_component: current_component)

          CreatePetition.call(@form, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("petitions.create.success", scope: "decidim.petitions.admin")
              redirect_to petitions_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("petitions.create.invalid", scope: "decidim.petitions.admin")
              render action: "new"
            end
          end
        end

        def edit
          enforce_permission_to :update, :petition, petition: petition
          @form = form(PetitionForm).from_model(petition)
        end

        def update
          enforce_permission_to :update, :petition, petition: petition
          @form = form(PetitionForm).from_params(params, current_component: current_component)

          UpdatePetition.call(@form, petition) do
            on(:ok) do
              flash[:notice] = I18n.t("petitions.update.success", scope: "decidim.petitions.admin")
              redirect_to petitions_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("petitions.update.invalid", scope: "decidim.petitions.admin")
              render action: "edit"
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :petition, petition: petition

          DestroyPetition.call(petition) do
            on(:ok) do
              flash[:notice] = I18n.t("petitions.destroy.success", scope: "decidim.petitions.admin")
              redirect_to petitions_path
            end
          end
        end

        def activate
          enforce_permission_to :update, :petition, petition: petition

          ActivatePetition.call(petition) do
            on(:ok) do
              flash[:notice] = I18n.t("petitions.activate.success", scope: "decidim.petitions.admin")
              redirect_to petitions_path
            end
          end
        end

        def decode
          enforce_permission_to :update, :petition, petition: petition

          DecodeConnector.call(petition, @command) do
            on(:ok) do
              flash[:notice] = I18n.t("petitions.decode.success.#{@command}", scope: "decidim.petitions.admin")
              redirect_to petitions_path
            end
          end
        end

        def deactivate
          enforce_permission_to :update, :petition, petition: petition

          DeactivatePetition.call(petition) do
            on(:ok) do
              flash[:notice] = I18n.t("petitions.deactivate.success", scope: "decidim.petitions.admin")
              redirect_to petitions_path
            end
          end
        end

        private

        def petition
          @petition ||= Petition.find_by(component: current_component, id: params[:id])
        end
      end
    end
  end
end
