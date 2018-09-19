# frozen_string_literal: true

require "spec_helper"

describe "Comments", type: :system, perform_enqueued: true do
  let!(:component) { create(:dpetitions_component, organization: organization) }
  let!(:commentable) { create(:dpetition, :open_ama, component: component) }

  let(:resource_path) { resource_locator(commentable).path }

  include_examples "comments"
end
