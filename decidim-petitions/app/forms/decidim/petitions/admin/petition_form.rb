# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class PetitionForm < Form
        include Decidim::TranslatableAttributes

        translatable_attribute :title, String
        translatable_attribute :summary, String
        translatable_attribute :description, String
        attribute :image
        attribute :json_schema, JSON
        attribute :json_attribute_info, JSON
        attribute :json_attribute_info_optional, JSON

        mimic :petition

        validates :title, :summary, :description, translatable_presence: true
        validates :json_schema, :json_attribute_info, :json_attribute_info_optional, presence: true
        validates :image, file_size: {
          less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size }
        }, file_content_type: { allow: ['image/jpeg', 'image/png'] }
      end
    end
  end
end
