# frozen_string_literal: true

RSpec.shared_examples "manage dpetitions" do
  let!(:dpetition) { create :dpetition, category: category, component: current_component }

  describe "updating a dpetition" do
    it "updates a dpetition" do
      visit_component_admin

      within find("tr", text: translated(dpetition.title)) do
        page.find(".action-icon--edit").click
      end

      within ".edit_dpetition" do
        fill_in_i18n(
          :dpetition_title,
          "#dpetition-title-tabs",
          en: "My new title",
          es: "Mi nuevo título",
          ca: "El meu nou títol"
        )

        find("*[type=submit]").click
      end

      within ".callout-wrapper" do
        expect(page).to have_content("successfully")
      end

      within "table" do
        expect(page).to have_content("My new title")
      end
    end

    context "when the dpetition has an author" do
      let!(:dpetition) { create(:dpetition, :with_author, component: current_component) }

      it "cannot edit the dpetition" do
        visit_component_admin

        within find("tr", text: translated(dpetition.title)) do
          expect(page).to have_no_selector(".action-icon--edit")
        end
      end
    end
  end

  describe "previewing dpetitions" do
    before do
      visit_component_admin
    end

    it "links the dpetition correctly" do
      link = find("a", text: translated(dpetition.title))
      expect(link[:href]).to include(resource_locator(dpetition).path)
    end

    it "shows a preview of the dpetition" do
      visit resource_locator(dpetition).path
      expect(page).to have_content(translated(dpetition.title))
    end
  end

  it "creates a new dpetition" do
    visit_component_admin

    within ".card-title" do
      page.find(".button.button--title").click
    end

    within ".new_dpetition" do
      fill_in_i18n(
        :dpetition_title,
        "#dpetition-title-tabs",
        en: "My dpetition",
        es: "Mi dpetition",
        ca: "El meu debat"
      )
      fill_in_i18n_editor(
        :dpetition_description,
        "#dpetition-description-tabs",
        en: "Long description",
        es: "Descripción más larga",
        ca: "Descripció més llarga"
      )
      fill_in_i18n_editor(
        :dpetition_instructions,
        "#dpetition-instructions-tabs",
        en: "Long instructions",
        es: "Instrucciones más largas",
        ca: "Instruccions més llargues"
      )
    end

    page.execute_script("$('#datetime_field_dpetition_start_time').focus()")
    page.find(".datepicker-dropdown .day", text: "12").click
    page.find(".datepicker-dropdown .hour", text: "10:00").click
    page.find(".datepicker-dropdown .minute", text: "10:50").click

    page.execute_script("$('#datetime_field_dpetition_end_time').focus()")
    page.find(".datepicker-dropdown .day", text: "12").click
    page.find(".datepicker-dropdown .hour", text: "12:00").click
    page.find(".datepicker-dropdown .minute", text: "12:50").click

    within ".new_dpetition" do
      select translated(category.name), from: :dpetition_decidim_category_id

      find("*[type=submit]").click
    end

    within ".callout-wrapper" do
      expect(page).to have_content("successfully")
    end

    within "table" do
      expect(page).to have_content("My dpetition")
    end
  end

  describe "deleting a dpetition" do
    let!(:dpetition2) { create(:dpetition, component: current_component) }

    before do
      visit current_path
    end

    it "deletes a dpetition" do
      within find("tr", text: translated(dpetition2.title)) do
        accept_confirm do
          page.find(".action-icon--remove").click
        end
      end

      within ".callout-wrapper" do
        expect(page).to have_content("successfully")
      end

      within "table" do
        expect(page).not_to have_content(translated(dpetition2.title))
      end
    end

    context "when the dpetition has an author" do
      let!(:dpetition2) { create(:dpetition, :with_author, component: current_component) }

      it "cannot delete the dpetition" do
        within find("tr", text: translated(dpetition2.title)) do
          expect(page).to have_no_selector(".action-icon--remove")
        end
      end
    end
  end
end
