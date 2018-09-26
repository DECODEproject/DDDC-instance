# frozen_string_literal: true

require_dependency "decidim/components/namer"

Decidim.register_component(:petitions) do |component|
  component.engine = Decidim::Petitions::Engine
  component.admin_engine = Decidim::Petitions::AdminEngine
  component.icon = "decidim/petitions/icon.svg"

  component.query_type = "Decidim::Petitions::PetitionsType"
  component.permissions_class_name = "Decidim::Petitions::Permissions"
  # component.on(:before_destroy) do |instance|
  #   # Code executed before removing the component
  # end

  # These actions permissions can be configured in the admin panel
  # component.actions = %w()

  component.settings(:global) do |settings|
    # Add your global settings
    # Available types: :integer, :boolean
    # settings.attribute :vote_limit, type: :integer, default: 0
    settings.attribute :chainspace_url, type: :string, default: ""
  end

  component.settings(:step) do |settings|
    settings.attribute :announcement, type: :text, translated: true, editor: true
    settings.attribute :votes_enabled, type: :boolean
  end

  component.register_resource(:petition) do |resource|
    # Register a optional resource that can be references from other resources.
    resource.model_class_name = "Decidim::Petitions::Petition"
    # resource.template = "decidim/petitions/some_resources/linked_some_resources"
  end

  component.register_stat :petitions_count, primary: true, priority: Decidim::StatsRegistry::MEDIUM_PRIORITY do |components, _start_at, _end_at|
    Decidim::Petitions::Petition.where(component: components).count
  end

  component.seeds do |participatory_space|
    component = Decidim::Component.create!(
      name: Decidim::Components::Namer.new(participatory_space.organization.available_locales, :petitions).i18n_name,
      manifest_name: :petitions,
      published_at: Time.current,
      participatory_space: participatory_space
    )
    author = Decidim::User.where(organization: component.organization).all.first
    2.times do
      petition = Decidim::Petitions::Petition.create!(
        component: component,
        title: Decidim::Faker::Localized.sentence(2),
        description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
          Decidim::Faker::Localized.paragraph(3)
        end,
        summary: Decidim::Faker::Localized.paragraph(1),
        author: author
      )
    end
  end
end
