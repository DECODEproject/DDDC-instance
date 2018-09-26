# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :petitions_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :petitions).i18n_name }
    manifest_name :petitions
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
