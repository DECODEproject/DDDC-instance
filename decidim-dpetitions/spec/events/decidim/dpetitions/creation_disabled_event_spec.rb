# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Dpetitions
    describe CreationDisabledEvent do
      include Decidim::ComponentPathHelper

      include_context "when a simple event"

      let(:event_name) { "decidim.events.dpetitions.creation_disabled" }
      let(:resource) { create(:dpetitions_component) }
      let(:participatory_space) { resource.participatory_space }
      let(:resource_path) { main_component_path(resource) }

      it_behaves_like "a simple event"

      describe "email_subject" do
        it "is generated correctly" do
          expect(subject.email_subject).to eq("Dpetition creation disabled in #{participatory_space_title}")
        end
      end

      describe "email_intro" do
        it "is generated correctly" do
          expect(subject.email_intro)
            .to eq("Dpetition creation is no longer active in #{participatory_space_title}. You can still participate in opened dpetitions from this page:")
        end
      end

      describe "email_outro" do
        it "is generated correctly" do
          expect(subject.email_outro)
            .to include("You have received this notification because you are following #{participatory_space_title}")
        end
      end

      describe "notification_title" do
        it "is generated correctly" do
          expect(subject.notification_title)
            .to eq("Dpetition creation is now disabled in <a href=\"#{participatory_space_url}\">#{participatory_space_title}</a>")
        end
      end
    end
  end
end
