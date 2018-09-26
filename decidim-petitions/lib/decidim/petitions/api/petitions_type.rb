# frozen_string_literal: true

module Decidim
  module Petitions
    PetitionsType = GraphQL::ObjectType.define do
      name "Petitions"
      description "The petitions"
      field :petition, PetitionType do
        argument :id, !types.ID, "The petition unique ID"
        resolve lambda { |_obj, args, ctx|
          Petition.find_by(id: args[:id], organization: ctx[:current_organization])
        }
      end
    end
  end
end
