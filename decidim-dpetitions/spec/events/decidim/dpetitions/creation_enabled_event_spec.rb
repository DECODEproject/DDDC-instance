# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Dpetitions
    describe CreationEnabledEvent do
      include Decidim::ComponentPathHelper

      include_context "when a simple event"

      let(:event_name) { "decidim.events.dpetitions.creation_enabled" }
      let(:resource) { create(:dpetitions_component) }
      let(:participatory_space) { resource.participatory_space }
      let(:resource_path) { main_component_path(resource) }

      it_behaves_like "a simple event"

      describe "email_subject" do
        it "is generated correctly" do
          expect(subject.email_subject).to eq("Dpetitions now available in #{participatory_space.title["en"]}")
        end
      end

      describe "email_intro" do
        it "is generated correctly" do
          expect(subject.email_intro)
            .to eq("You can now start new dpetitions in #{participatory_space_title}! Start participating in this page:")
        end
      end

      describe "email_outro" do
        it "is generated correctly" do
          expect(subject.email_outro)
            .to include("You have received this notification because you are following #{participatory_space.title["en"]}")
        end
      end

      describe "notification_title" do
        it "is generated correctly" do
          expect(subject.notification_title)
            .to eq("You can now start <a href=\"#{resource_path}\">new dpetitions</a> in <a href=\"#{participatory_space_url}\">#{participatory_space.title["en"]}</a>")
        end
      end
    end
  end
end
