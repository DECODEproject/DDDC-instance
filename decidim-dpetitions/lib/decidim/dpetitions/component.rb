# frozen_string_literal: true

require_dependency "decidim/components/namer"

Decidim.register_component(:dpetitions) do |component|
  component.engine = Decidim::Dpetitions::Engine
  component.admin_engine = Decidim::Dpetitions::AdminEngine
  component.icon = "decidim/dpetitions/icon.svg"
  component.permissions_class_name = "Decidim::Dpetitions::Permissions"

  component.data_portable_entities = ["Decidim::Dpetitions::Dpetition"]

  component.on(:before_destroy) do |instance|
    raise StandardError, "Can't remove this component" if Decidim::Dpetitions::Dpetition.where(component: instance).any?
  end

  component.settings(:global) do |settings|
    settings.attribute :comments_enabled, type: :boolean, default: true
    settings.attribute :announcement, type: :text, translated: true, editor: true
  end

  component.settings(:step) do |settings|
    settings.attribute :creation_enabled, type: :boolean, default: false
    settings.attribute :comments_blocked, type: :boolean, default: false
    settings.attribute :announcement, type: :text, translated: true, editor: true
  end

  component.register_stat :dpetitions_count, primary: true, priority: Decidim::StatsRegistry::HIGH_PRIORITY do |components, _start_at, _end_at|
    Decidim::Dpetitions::Dpetition.where(component: components).count
  end

  component.register_resource(:dpetition) do |resource|
    resource.model_class_name = "Decidim::Dpetitions::Dpetition"
    resource.card = "decidim/dpetitions/dpetition"
  end

  component.actions = %w(create)

  component.seeds do |participatory_space|
    component = Decidim::Component.create!(
      name: Decidim::Components::Namer.new(participatory_space.organization.available_locales, :dpetitions).i18n_name,
      manifest_name: :dpetitions,
      published_at: Time.current,
      participatory_space: participatory_space
    )

    3.times do
      dpetition = Decidim::Dpetitions::Dpetition.create!(
        component: component,
        category: participatory_space.categories.sample,
        title: Decidim::Faker::Localized.sentence(2),
        description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
          Decidim::Faker::Localized.paragraph(3)
        end,
        instructions: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
          Decidim::Faker::Localized.paragraph(3)
        end,
        start_time: 3.weeks.from_now,
        end_time: 3.weeks.from_now + 4.hours
      )

      Decidim::Comments::Seed.comments_for(dpetition)
    end
  end
end
