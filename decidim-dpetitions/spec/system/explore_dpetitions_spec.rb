# frozen_string_literal: true

require "spec_helper"

describe "Explore dpetitions", type: :system do
  include_context "with a component"
  let(:manifest_name) { "dpetitions" }

  let(:organization) { create(:organization) }
  let(:participatory_process) { create(:participatory_process, :with_steps, organization: organization) }
  let(:current_component) { create :dpetitions_component, participatory_space: participatory_process }
  let(:dpetitions_count) { 5 }
  let!(:dpetitions) do
    create_list(
      :dpetition,
      dpetitions_count,
      component: current_component,
      start_time: Time.zone.local(2016, 12, 13, 14, 15),
      end_time: Time.zone.local(2016, 12, 13, 16, 17)
    )
  end

  before do
    switch_to_host(organization.host)
  end

  describe "index" do
    let(:path) { decidim_participatory_process_dpetitions.dpetitions_path(participatory_process_slug: participatory_process.slug, component_id: current_component.id) }

    it "lists all dpetitions for the given process" do
      visit path

      expect(page).to have_selector("article.card", count: dpetitions_count)

      dpetitions.each do |dpetition|
        expect(page).to have_content(translated(dpetition.title))
      end
    end

    context "when there are a lot of dpetitions" do
      before do
        create_list(:dpetition, Decidim::Paginable::OPTIONS.first + 5, component: component)
      end

      it "paginates them" do
        visit_component

        expect(page).to have_css(".card--dpetition", count: Decidim::Paginable::OPTIONS.first)

        click_link "Next"

        expect(page).to have_selector(".pagination .current", text: "2")

        expect(page).to have_css(".card--dpetition", count: 5)
      end
    end

    context "when there's an announcement set" do
      let(:announcement) do
        { en: "Important announcement" }
      end

      context "with the component's settings" do
        before do
          component.update!(settings: { announcement: announcement })
        end

        it "shows the announcement" do
          visit_component
          expect(page).to have_content("Important announcement")
        end
      end

      context "with the step's settings" do
        before do
          component.update!(
            step_settings: {
              component.participatory_space.active_step.id => {
                announcement: announcement
              }
            }
          )
        end

        it "shows the announcement" do
          visit_component
          expect(page).to have_content("Important announcement")
        end
      end
    end

    context "when filtering" do
      context "when filtering by origin" do
        context "with 'official' origin" do
          it "lists the filtered dpetitions" do
            create_list(:dpetition, 2, component: component)
            create(:dpetition, :with_author, component: component)
            visit_component

            within ".filters" do
              choose "Official"
            end

            expect(page).to have_css(".card--dpetition", count: 2)
            expect(page).to have_content("2 DEBATES")
          end
        end

        context "with 'citizens' origin" do
          it "lists the filtered dpetitions" do
            create_list(:dpetition, 2, :with_author, component: component)
            create(:dpetition, component: component)
            visit_component

            within ".filters" do
              choose "Citizens"
            end

            expect(page).to have_css(".card--dpetition", count: 2)
            expect(page).to have_content("2 DEBATES")
          end
        end
      end

      context "when filtering by category" do
        before do
          login_as user, scope: :user
        end

        it "can be filtered by category" do
          create_list(:dpetition, 3, component: component)
          create(:dpetition, component: component, category: category)

          visit_component

          within "form.new_filter" do
            select category.name[I18n.locale.to_s], from: :filter_category_id
          end

          expect(page).to have_css(".card--dpetition", count: 1)
        end
      end
    end

    context "with hidden dpetitions" do
      let(:dpetition) { dpetitions.last }

      before do
        create :moderation, :hidden, reportable: dpetition
      end

      it "does not list the hidden dpetitions" do
        visit path

        expect(page).to have_selector("article.card", count: dpetitions_count - 1)

        expect(page).to have_no_content(translated(dpetition.title))
      end
    end
  end

  describe "show" do
    let(:path) do
      decidim_participatory_process_dpetitions.dpetition_path(
        id: dpetition.id,
        participatory_process_slug: participatory_process.slug,
        component_id: current_component.id
      )
    end
    let(:dpetitions_count) { 1 }
    let(:dpetition) { dpetitions.first }

    before do
      visit path
    end

    it "shows all dpetition info" do
      expect(page).to have_i18n_content(dpetition.title)
      expect(page).to have_i18n_content(dpetition.description)
      expect(page).to have_i18n_content(dpetition.information_updates)
      expect(page).to have_i18n_content(dpetition.instructions)

      within ".section.view-side" do
        expect(page).to have_content(13)
        expect(page).to have_content(/December/i)
        expect(page).to have_content("14:15 - 16:17")
      end
    end

    context "without category" do
      it "does not show any tag" do
        expect(page).not_to have_selector("ul.tags.tags--dpetition")
      end
    end

    context "with a category" do
      let(:dpetition) do
        dpetition = dpetitions.first
        dpetition.category = create :category, participatory_space: participatory_process
        dpetition.save
        dpetition
      end

      it "shows tags for category" do
        expect(page).to have_selector("ul.tags.tags--dpetition")

        within "ul.tags.tags--dpetition" do
          expect(page).to have_content(translated(dpetition.category.name))
        end
      end
    end
  end
end
