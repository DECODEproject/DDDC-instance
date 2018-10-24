# frozen_string_literal: true

module Decidim
  module Petitions
    # This is the engine that runs on the public interface of `Petitions`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Petitions::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :petitions do
          member do
            post :activate
            post :deactivate
          end
        end
        root to: "petitions#index"
      end

      def load_seed
        nil
      end
    end
  end
end
