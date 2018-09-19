# frozen_string_literal: true

require "spec_helper"

describe Decidim::Dpetitions::Admin::UpdateDpetition do
  subject { described_class.new(form, dpetition) }

  let(:dpetition) { create :dpetition }
  let(:organization) { dpetition.component.organization }
  let(:category) { create :category, participatory_space: dpetition.component.participatory_space }
  let(:user) { create :user, :admin, :confirmed, organization: organization }
  let(:form) do
    double(
      invalid?: invalid,
      current_user: user,
      title: { en: "title" },
      description: { en: "description" },
      information_updates: { en: "information_updates" },
      instructions: { en: "instructions" },
      start_time: 1.day.from_now,
      end_time: 1.day.from_now + 1.hour,
      category: category
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
    it "updates the dpetition" do
      subject.call
      expect(translated(dpetition.title)).to eq "title"
      expect(translated(dpetition.description)).to eq "description"
      expect(translated(dpetition.information_updates)).to eq "information_updates"
      expect(translated(dpetition.instructions)).to eq "instructions"
    end

    it "sets the category" do
      subject.call
      expect(dpetition.category).to eq category
    end

    it "traces the action", versioning: true do
      expect(Decidim.traceability)
        .to receive(:update!)
        .with(dpetition, user, hash_including(:category, :title, :description, :information_updates, :instructions, :end_time, :start_time))
        .and_call_original

      expect { subject.call }.to change(Decidim::ActionLog, :count)
      action_log = Decidim::ActionLog.last
      expect(action_log.version).to be_present
      expect(action_log.version.event).to eq "update"
    end
  end
end
