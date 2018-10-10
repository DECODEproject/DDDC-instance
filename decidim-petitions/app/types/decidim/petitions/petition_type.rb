# frozen_string_literal: true

module Decidim
  module Petitions
    PetitionType = GraphQL::ObjectType.define do
      name "Petition"
      description "The petitions"
      field :id, !types.ID, "Petition unique ID"
      field :title, JSONType, "Petition Title"
      field :author, !types.String, "Author name" do
        resolve ->(obj, _args, _ctx) { obj.author.name }
      end
      field :votes, !types.Int, "Petition votes"
      field :submitted_to, !types.String, "Petition submitted to" do
        resolve ->(obj, _args, _ctx) { obj.organization.name }
      end

      field :description, JSONType, "Description of the petition."
      field :json_schema, JSONType, "Schema"

      field :image, !types.String, "Petition image square" do
        resolve ->(obj, _args, _ctx) { obj.image.url(:square) }
      end
    end

    JSONType = GraphQL::ScalarType.define do
      name "JSONType"
      coerce_input ->(value, _ctx) { JSON.parse(value) }
      coerce_result ->(value, _ctx) { value }
    end
  end
end
