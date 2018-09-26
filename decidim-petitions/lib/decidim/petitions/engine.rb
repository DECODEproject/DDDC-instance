# frozen_string_literal: true

require "rails"
require "decidim/core"
require "decidim/petitions/query_extensions"

module Decidim
  module Petitions
    # This is the engine that runs on the public interface of petitions.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Petitions

      routes do
        # Add engine routes here
        # resources :petitions
        root to: "petitions#index"
      end

      initializer "decidim_petitions.assets" do |app|
        app.config.assets.precompile += %w[decidim_petitions_manifest.js decidim_petitions_manifest.css]
      end

      initializer "decidim_petitions.query_extensions" do
        Decidim::Api::QueryType.define do
          QueryExtensions.define(self)
        end
      end
    end
  end
end
