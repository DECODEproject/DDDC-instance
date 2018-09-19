# frozen_string_literal: true

require "spec_helper"

describe Decidim::Dpetitions::CreateDpetitionEvent do
  include_context "when a simple event"

  let(:resource) { create :dpetition, :with_author }
  let(:space) { resource.participatory_space }
  let(:event_name) { "decidim.events.dpetitions.dpetition_created" }
  let(:space_path) { resource_locator(space).path }
  let(:extra) { { type: type.to_s } }

  context "when the notification is for user followers" do
    let(:type) { :user }
    let(:i18n_scope) { "decidim.events.dpetitions.create_dpetition_event.user_followers" }

    it_behaves_like "a simple event"

    describe "email_subject" do
      it "is generated correctly" do
        expect(subject.email_subject).to eq("New dpetition by @#{author.nickname}")
      end
    end

    describe "email_intro" do
      it "is generated correctly" do
        expect(subject.email_intro)
          .to eq("Hi,\n#{author.name} @#{author.nickname}, who you are following, has created a new dpetition, check it out and contribute:")
      end
    end

    describe "email_outro" do
      it "is generated correctly" do
        expect(subject.email_outro)
          .to eq("You have received this notification because you are following @#{author.nickname}. You can stop receiving notifications following the previous link.")
      end
    end

    describe "notification_title" do
      it "is generated correctly" do
        expect(subject.notification_title)
          .to include("The <a href=\"#{resource_path}\">#{resource_title}</a> dpetition was created by ")

        expect(subject.notification_title)
          .to include("<a href=\"/profiles/#{author.nickname}\">#{author.name} @#{author.nickname}</a>.")
      end
    end
  end

  context "when the notification is for space followers" do
    let(:type) { :space }
    let(:i18n_scope) { "decidim.events.dpetitions.create_dpetition_event.space_followers" }

    it_behaves_like "a simple event"

    describe "email_subject" do
      it "is generated correctly" do
        expect(subject.email_subject).to eq("New dpetition on #{translated(space.title)}")
      end
    end

    describe "email_intro" do
      it "is generated correctly" do
        expect(subject.email_intro)
          .to eq("Hi,\nA new dpetition has been created on the #{translated(space.title)} participatory space, check it out and contribute:")
      end
    end

    describe "email_outro" do
      it "is generated correctly" do
        expect(subject.email_outro)
          .to eq("You have received this notification because you are following the #{translated(space.title)} participatory space. " \
          "You can stop receiving notifications following the previous link.")
      end
    end

    describe "notification_title" do
      it "is generated correctly" do
        expect(subject.notification_title)
          .to include("The <a href=\"#{resource_path}\">#{resource_title}</a> dpetition was created on ")

        expect(subject.notification_title)
          .to include("<a href=\"#{space_path}\">#{translated(space.title)}</a>.")
      end
    end
  end
end
