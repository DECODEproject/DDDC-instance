# frozen_string_literal: true

require "spec_helper"

describe "Admin manages dpetitions", type: :system do
  let(:manifest_name) { "dpetitions" }

  include_context "when managing a component as an admin"
  it_behaves_like "manage dpetitions"
  it_behaves_like "manage announcements"

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit_component_admin
  end
end
