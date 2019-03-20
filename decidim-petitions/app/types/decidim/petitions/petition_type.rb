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
      field :attribute_id, !types.String, "Attribute ID for Decode APIs"
      field :credential_issuer_api_url, !types.String, "Credential Issuer API URL for Decode APIs" do
        resolve ->(obj, _args, _ctx) { Rails.application.secrets.decode[:credential_issuer][:url] }
      end
      field :petitions_api_url, !types.String, "Petitions API URL for Decode APIs" do
        resolve ->(obj, _args, _ctx) { Rails.application.secrets.decode[:petitions][:url] }
      end
    end

    JSONType = GraphQL::ScalarType.define do
      name "JSONType"
      coerce_input ->(value, _ctx) { JSON.parse(value) }
      coerce_result ->(value, _ctx) { value }
    end
  end
end
