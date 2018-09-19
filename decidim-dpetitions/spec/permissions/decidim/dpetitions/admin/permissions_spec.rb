# frozen_string_literal: true

require "spec_helper"

describe Decidim::Dpetitions::Admin::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:user) { create :user, organization: dpetitions_component.organization }
  let(:context) do
    {
      current_component: dpetitions_component,
      dpetition: dpetition
    }
  end
  let(:dpetitions_component) { create :dpetitions_component }
  let(:dpetition) { create :dpetition, component: dpetitions_component }
  let(:permission_action) { Decidim::PermissionAction.new(action) }

  context "when scope is not admin" do
    let(:action) do
      { scope: :foo, action: :bar, subject: :dpetition }
    end

    it_behaves_like "permission is not set"
  end

  context "when subject is not dpetition" do
    let(:action) do
      { scope: :admin, action: :bar, subject: :foo }
    end

    it_behaves_like "permission is not set"
  end

  context "when action is a random one" do
    let(:action) do
      { scope: :admin, action: :bar, subject: :dpetition }
    end

    it_behaves_like "permission is not set"
  end

  describe "dpetition creation" do
    let(:action) do
      { scope: :admin, action: :create, subject: :dpetition }
    end

    it { is_expected.to eq true }
  end

  describe "dpetition update" do
    let(:action) do
      { scope: :admin, action: :update, subject: :dpetition }
    end

    context "when the dpetition is official" do
      it { is_expected.to eq true }
    end

    context "when dpetition is not official" do
      let(:dpetition) { create :dpetition, author: user, component: dpetitions_component }

      it { is_expected.to eq false }
    end
  end

  describe "dpetition delete" do
    let(:action) do
      { scope: :admin, action: :delete, subject: :dpetition }
    end

    context "when the dpetition is official" do
      it { is_expected.to eq true }
    end

    context "when dpetition is not official" do
      let(:dpetition) { create :dpetition, author: user, component: dpetitions_component }

      it { is_expected.to eq false }
    end
  end
end
