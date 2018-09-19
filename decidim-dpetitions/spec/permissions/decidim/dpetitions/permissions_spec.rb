# frozen_string_literal: true

require "spec_helper"

describe Decidim::Dpetitions::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:user) { create :user, organization: dpetitions_component.organization }
  let(:context) do
    {
      current_component: dpetitions_component,
      current_settings: current_settings,
      dpetition: dpetition,
      component_settings: nil
    }
  end
  let(:dpetitions_component) { create :dpetitions_component }
  let(:dpetition) { create :dpetition, component: dpetitions_component }
  let(:current_settings) do
    double(settings.merge(extra_settings))
  end
  let(:settings) do
    {
      creation_enabled?: false
    }
  end
  let(:extra_settings) { {} }
  let(:permission_action) { Decidim::PermissionAction.new(action) }

  context "when scope is admin" do
    let(:action) do
      { scope: :admin, action: :foo, subject: :dpetition }
    end

    it_behaves_like "delegates permissions to", Decidim::Dpetitions::Admin::Permissions
  end

  context "when scope is not public" do
    let(:action) do
      { scope: :foo, action: :vote, subject: :dpetition }
    end

    it_behaves_like "permission is not set"
  end

  context "when subject is not a dpetition" do
    let(:action) do
      { scope: :public, action: :vote, subject: :foo }
    end

    it_behaves_like "permission is not set"
  end

  context "when creating a dpetition" do
    let(:action) do
      { scope: :public, action: :create, subject: :dpetition }
    end

    context "when creation is disabled" do
      let(:extra_settings) { { creation_enabled?: false } }

      it { is_expected.to eq false }
    end

    context "when user is authorized" do
      let(:extra_settings) { { creation_enabled?: true } }

      it { is_expected.to eq true }
    end
  end

  context "when reporting a dpetition" do
    let(:action) do
      { scope: :public, action: :report, subject: :dpetition }
    end

    it { is_expected.to eq true }
  end
end
