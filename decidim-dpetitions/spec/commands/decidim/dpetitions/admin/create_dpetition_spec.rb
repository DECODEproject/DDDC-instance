# frozen_string_literal: true

require "spec_helper"

describe Decidim::Dpetitions::Admin::CreateDpetition do
  subject { described_class.new(form) }

  let(:organization) { create :organization, available_locales: [:en, :ca, :es], default_locale: :en }
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:current_component) { create :component, participatory_space: participatory_process, manifest_name: "dpetitions" }
  let(:category) { create :category, participatory_space: participatory_process }
  let(:user) { create :user, :admin, :confirmed, organization: organization }
  let(:form) do
    double(
      invalid?: invalid,
      title: { en: "title" },
      description: { en: "description" },
      information_updates: { en: "information updates" },
      instructions: { en: "instructions" },
      start_time: 1.day.from_now,
      end_time: 1.day.from_now + 1.hour,
      category: category,
      current_user: user,
      current_component: current_component
    )
  end
  let(:invalid) { false }

  context "when the form is not valid" do
    let(:invalid) { true }

    it "is not valid" do
      expect { subject.call }.to broadcast(:invalid)
    end
  end

  context "when everything is ok" do
    let(:dpetition) { Decidim::Dpetitions::Dpetition.last }

    it "creates the dpetition" do
      expect { subject.call }.to change { Decidim::Dpetitions::Dpetition.count }.by(1)
    end

    it "sets the category" do
      subject.call
      expect(dpetition.category).to eq category
    end

    it "sets the component" do
      subject.call
      expect(dpetition.component).to eq current_component
    end

    it "traces the action", versioning: true do
      expect(Decidim.traceability)
        .to receive(:create!)
        .with(Decidim::Dpetitions::Dpetition, user, hash_including(:category, :title, :description, :information_updates, :instructions, :end_time, :start_time, :component))
        .and_call_original

      expect { subject.call }.to change(Decidim::ActionLog, :count)
      action_log = Decidim::ActionLog.last
      expect(action_log.version).to be_present
      expect(action_log.version.event).to eq "create"
    end

    describe "events" do
      let(:space_follower) { create(:user, organization: organization) }
      let!(:space_follow) { create :follow, followable: participatory_process, user: space_follower }

      it "notifies the change to the author followers" do
        expect(Decidim::EventsManager)
          .to receive(:publish)
          .with(
            event: "decidim.events.dpetitions.dpetition_created",
            event_class: Decidim::Dpetitions::CreateDpetitionEvent,
            resource: kind_of(Decidim::Dpetitions::Dpetition),
            recipient_ids: [space_follower.id],
            extra: { type: "participatory_space" }
          )

        subject.call
      end
    end
  end
end
