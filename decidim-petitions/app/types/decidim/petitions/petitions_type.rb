# frozen_string_literal: true

module Decidim
  module Petitions
    PetitionsType = GraphQL::ObjectType.define do
      interfaces [-> { Decidim::Core::ComponentInterface }]

      name "Petitions"
      description "A petitions component of a participatory space."

      connection :petitions, PetitionType.connection_type do
        resolve ->(component, _args, _ctx) {
                  PetitionsTypeHelper.base_scope(component).includes(:component)
                }
      end

      field(:petition, PetitionType) do
        argument :id, !types.ID

        resolve ->(component, args, _ctx) {
          PetitionsTypeHelper.base_scope(component).find_by(id: args[:id])
        }
      end
    end

    module PetitionsTypeHelper
      def self.base_scope(component)
        Petition
          .where(component: component)
          .published
      end
    end
  end
end
