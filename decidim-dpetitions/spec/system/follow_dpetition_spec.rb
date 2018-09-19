# frozen_string_literal: true

require "spec_helper"

describe "Follow dpetitions", type: :system do
  let(:manifest_name) { "dpetitions" }

  let!(:followable) do
    create(:dpetition, component: component)
  end

  include_examples "follows"
end
