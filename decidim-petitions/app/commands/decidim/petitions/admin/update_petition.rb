# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class UpdatePetition < Rectify::Command
        def initialize(form, petition)
          @form = form
          @petition = petition
        end

        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            update_petition!
          end

          broadcast(:ok, petition)
        end

        private

        attr_reader :form, :petition

        def update_petition!
          petition.update!(
            title: form.title,
            summary: form.summary,
            description: form.description,
            image: form.image,
            json_schema: JSON.parse(form.json_schema),
            json_attribute_info: JSON.parse(form.json_attribute_info)
          )
        end
      end
    end
  end
end
