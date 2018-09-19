# frozen_string_literal: true

require "searchlight"
require "kaminari"

module Decidim
  module Dpetitions
    # This is the engine that runs on the public interface of `decidim-dpetitions`.
    # It mostly handles rendering the created dpetition associated to a participatory
    # process.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Dpetitions

      routes do
        resources :dpetitions, only: [:index, :show, :new, :create]
        root to: "dpetitions#index"
      end

      initializer "decidim_changes" do
        Decidim::SettingsChange.subscribe "dpetitions" do |changes|
          Decidim::Dpetitions::SettingsChangeJob.perform_later(
            changes[:component_id],
            changes[:previous_settings],
            changes[:current_settings]
          )
        end
      end

      initializer "decidim_meetings.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Dpetitions::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Dpetitions::Engine.root}/app/views") # for partials
      end
    end
  end
end
