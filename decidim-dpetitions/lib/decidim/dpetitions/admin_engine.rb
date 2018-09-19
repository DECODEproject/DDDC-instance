# frozen_string_literal: true

module Decidim
  module Dpetitions
    # This is the engine that runs on the public interface of `decidim-dpetitions`.
    # It mostly handles rendering the created dpetition associated to a participatory
    # process.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Dpetitions::Admin

      paths["db/migrate"] = nil

      routes do
        resources :dpetitions
        root to: "dpetitions#index"
      end

      def load_seed
        nil
      end
    end
  end
end
