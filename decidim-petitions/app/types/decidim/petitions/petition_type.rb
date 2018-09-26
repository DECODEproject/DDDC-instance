# frozen_string_literal: true

module Decidim
  module Petitions
    PetitionType = GraphQL::ObjectType.define do
      name "Petition"
      description "The petitions"
      field :id, !types.ID, "Petition unique ID"
      field :title, !types.String, "Petition Title"
      field :author, !types.String, "Author name" do
        resolve ->(obj, _args, _ctx) { obj.author.name }
      end
      field :submitted_to, !types.String, "Petition submitted to" do
        resolve ->(obj, _, _) { obj.organization.name }
      end

      field :description, !types.String, "Description of the petition."
    end
  end
end
