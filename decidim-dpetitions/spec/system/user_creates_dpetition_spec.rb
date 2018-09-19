# frozen_string_literal: true

require "spec_helper"

describe "User creates dpetition", type: :system do
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

  context "when creating a new dpetition" do
    let(:user) { create :user, :confirmed, organization: organization }
    let!(:category) { create :category, participatory_space: participatory_space }

    context "when the user is logged in" do
      before do
        login_as user, scope: :user
      end

      context "with creation enabled" do
        let!(:component) do
          create(:dpetitions_component,
                 :with_creation_enabled,
                 participatory_space: participatory_process)
        end

        it "creates a new dpetition", :slow do
          visit_component

          click_link "New dpetition"

          within ".new_dpetition" do
            fill_in :dpetition_title, with: "Should Oriol be president?"
            fill_in :dpetition_description, with: "Would he solve everything?"
            select translated(category.name), from: :dpetition_category_id

            find("*[type=submit]").click
          end

          expect(page).to have_content("successfully")
          expect(page).to have_content("Should Oriol be president?")
          expect(page).to have_content("Would he solve everything?")
          expect(page).to have_content(translated(category.name))
          expect(page).to have_selector(".author-data", text: user.name)
        end

        context "when creating as a user group" do
          let!(:user_group) { create :user_group, :verified, organization: organization, users: [user] }

          it "creates a new dpetition", :slow do
            visit_component

            click_link "New dpetition"

            within ".new_dpetition" do
              fill_in :dpetition_title, with: "Should Oriol be president?"
              fill_in :dpetition_description, with: "Would he solve everything?"
              select translated(category.name), from: :dpetition_category_id
              select user_group.name, from: :dpetition_user_group_id

              find("*[type=submit]").click
            end

            expect(page).to have_content("successfully")
            expect(page).to have_content("Should Oriol be president?")
            expect(page).to have_content("Would he solve everything?")
            expect(page).to have_content(translated(category.name))
            expect(page).to have_selector(".author-data", text: user_group.name)
          end
        end

        context "when the user isn't authorized" do
          before do
            permissions = {
              create: {
                authorization_handler_name: "dummy_authorization_handler"
              }
            }

            component.update!(permissions: permissions)
          end

          it "shows a modal dialog" do
            visit_component
            click_link "New dpetition"
            expect(page).to have_content("Authorization required")
          end
        end
      end

      context "when creation is not enabled" do
        it "does not show the creation button" do
          visit_component
          expect(page).to have_no_link("New dpetition")
        end
      end
    end
  end
end
