# frozen_string_literal: true

require_dependency "decidim/components/namer"

Decidim.register_component(:petitions) do |component|
  component.engine = Decidim::Petitions::Engine
  component.admin_engine = Decidim::Petitions::AdminEngine
  component.icon = "decidim/petitions/icon.svg"

  component.permissions_class_name = "Decidim::Petitions::Permissions"
  # component.on(:before_destroy) do |instance|
  #   # Code executed before removing the component
  # end

  # These actions permissions can be configured in the admin panel
  # component.actions = %w()

  component.settings(:global) do |settings|
    settings.attribute :credential_issuer_api_url, type: :string, default: "https://credentials.decodeproject.eu"
    settings.attribute :credential_issuer_api_user, type: :string, default: ""
    settings.attribute :credential_issuer_api_pass, type: :string, default: ""
    settings.attribute :petitions_api_url, type: :string, default: "https://petitions.decodeproject.eu"
    settings.attribute :petitions_api_user, type: :string, default: ""
    settings.attribute :petitions_api_pass, type: :string, default: ""
    settings.attribute :dashboard_api_url, type: :string, default: ""
  end  

  component.settings(:step) do |settings|
    settings.attribute :announcement, type: :text, translated: true, editor: true
    settings.attribute :votes_enabled, type: :boolean
  end

  component.register_resource(:petition) do |resource|
    resource.model_class_name = "Decidim::Petitions::Petition"
    resource.card = "decidim/petitions/petition"
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
        author: author,
        json_schema: {
          "mandatory": [
            {
              "predicate": "schema:addressLocality",
              "object": "Barcelona",
              "scope": "can-access",
              "provenance": {
                "url": "http://example.com"
              }
            }
          ],
          "optional": [
            {
              "predicate": "schema:dateOfBirth",
              "object": "voter",
              "scope": "can-access"
            },
            {
              "predicate": "schema:gender",
              "object": "voter",
              "scope": "can-access"
            }
          ]
        },
        json_attribute_info: [
          {
            "name": "codes",
            "type": "str",
            "value_set": [ "eih5O","nuu3S","Pha6x","lahT4","Ri3ex","Op2ii","EG5th","ca5Ca","TuSh1","ut0iY","Eing8","Iep1H","yei2A","ahf3I","Oaf8f","nai1H","aib5V","ohH5v","eim2E","Nah5l","ooh5C","Uqu3u","Or2ei","aF9fa","ooc8W" ]
          }
        ],
        json_attribute_info_optional: [
          { "k": 2, "name": "age", "type": "str", "value_set": [ "0-19", "20-29", "30-39", ">40" ] },
          { "k": 2, "name": "gender", "type": "str", "value_set": [ "F", "M", "O" ] },
          { "k": 2, "name": "district", "type": "str", "value_set": [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" ] }
        ]
      )
    end
  end
end
