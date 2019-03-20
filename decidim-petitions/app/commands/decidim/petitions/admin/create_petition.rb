# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class CreatePetition < Rectify::Command
        def initialize(form, current_user)
          @form = form
          @current_user = current_user
        end

        def call
          return broadcast(:invalid) if @form.invalid?

          transaction do
            create_petition!
          end

          broadcast(:ok, @petition)
        end

        private

        def create_petition!
          @petition = Petition.create!(
            title: @form.title,
            summary: @form.summary,
            json_schema: JSON.parse(@form.json_schema),
            json_attribute_info: JSON.parse(@form.json_attribute_info),
            image: @form.image,
            description: @form.description,
            component: @form.current_component,
            author: @current_user
          )
        end
      end
    end
  end
end
