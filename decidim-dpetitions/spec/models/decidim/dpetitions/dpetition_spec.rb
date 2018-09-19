# frozen_string_literal: true

require "spec_helper"

describe Decidim::Dpetitions::Dpetition do
  subject { dpetition }

  let(:dpetition) { build :dpetition }

  it { is_expected.to be_valid }
  it { is_expected.to be_versioned }

  include_examples "has component"
  include_examples "has category"

  context "without a title" do
    let(:dpetition) { build :dpetition, title: nil }

    it { is_expected.not_to be_valid }
  end

  describe "official?" do
    context "when no author is set" do
      it { is_expected.to be_official }
    end

    context "when author is set" do
      let(:dpetition) { build :dpetition, :with_author }

      it { is_expected.not_to be_official }
    end

    context "when it is authored by a user group" do
      let(:dpetition) { build :dpetition, :with_user_group_author }

      it { is_expected.not_to be_official }
    end
  end

  describe "ama?" do
    context "when it has both start_time and end_time set" do
      let(:dpetition) { build :dpetition, title: nil }

      it { is_expected.to be_ama }
    end

    context "when it doesn't have both start_time and end_time set" do
      let(:dpetition) { build :dpetition, end_time: nil }

      it { is_expected.not_to be_ama }
    end
  end

  describe "open_ama?" do
    context "when it is not an AMA dpetition" do
      before do
        allow(dpetition).to receive(:ama?).and_return(false)
      end

      it { is_expected.not_to be_open_ama }
    end

    context "when it is an AMA dpetition" do
      context "when current time is between the range" do
        let(:dpetition) { build :dpetition, start_time: 1.day.ago, end_time: 1.day.from_now }

        it { is_expected.to be_open_ama }
      end

      context "when current time is not between the range" do
        let(:dpetition) { build :dpetition, start_time: 1.day.from_now, end_time: 2.days.from_now }

        it { is_expected.not_to be_open_ama }
      end
    end
  end

  describe "accepts_new_comments?" do
    subject { dpetition.accepts_new_comments? }

    context "when it is not an open dpetition" do
      let(:dpetition) { build :dpetition, start_time: 2.days.ago, end_time: 1.day.ago }

      it { is_expected.to be_falsey }
    end

    context "when it is an open dpetition" do
      let(:dpetition) { build :dpetition, :open_ama }

      context "when it is not commentable" do
        before do
          allow(dpetition).to receive(:commentable?).and_return(false)
        end

        it { is_expected.to be_falsey }
      end

      context "when it is commentable" do
        before do
          allow(dpetition).to receive(:commentable?).and_return(true)
        end

        context "when comments are blocked" do
          before do
            allow(dpetition)
              .to receive(:comments_blocked?).and_return(true)
          end

          it { is_expected.to be_falsey }
        end

        context "when comments are not blocked" do
          before do
            allow(dpetition)
              .to receive(:comments_blocked?).and_return(false)
          end

          it { is_expected.to be_truthy }
        end
      end
    end
  end
end
