# frozen_string_literal: true

module Decidim
  module Petitions
    module Admin
      class PetitionForm < Form
        include TranslatableAttributes

        translatable_attribute :title, String
        translatable_attribute :summary, String
        translatable_attribute :description, String
        attribute :json_schema, JSON

        mimic :petition

        # validates :title, translatable_presence: true
        # validates :summary, translatable_presence: true
        # validates :description, translatable_attribute: true
      end
    end
  end
end
