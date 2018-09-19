# frozen_string_literal: true

require "spec_helper"

describe Decidim::Dpetitions::DpetitionSearch do
  subject { described_class.new(params).results }

  let(:current_component) { create :component, manifest_name: "dpetitions" }
  let(:parent_category) { create :category, participatory_space: current_component.participatory_space }
  let(:subcategory) { create :subcategory, parent: parent_category }
  let!(:dpetition1) do
    create(
      :dpetition,
      component: current_component,
      start_time: 1.day.from_now,
      category: parent_category
    )
  end
  let!(:dpetition2) do
    create(
      :dpetition,
      :with_author,
      component: current_component,
      start_time: 2.days.from_now,
      category: subcategory
    )
  end
  let(:external_dpetition) { create :dpetition }
  let(:component_id) { current_component.id }
  let(:organization_id) { current_component.organization.id }
  let(:default_params) { { component: current_component } }
  let(:params) { default_params }

  describe "base query" do
    context "when no component is passed" do
      let(:default_params) { { component: nil } }

      it "raises an error" do
        expect { subject }.to raise_error(StandardError, "Missing component")
      end
    end
  end

  describe "filters" do
    describe "component_id" do
      it "only returns dpetitions from the given component" do
        external_dpetition = create(:dpetition)

        expect(subject).not_to include(external_dpetition)
      end
    end

    describe "search_text filter" do
      let(:params) { default_params.merge(search_text: search_text) }
      let(:search_text) { "dog" }

      before do
        dpetition1.title["en"] = "Do you like my dog?"
        dpetition1.save
      end

      it "searches the title or the description in i18n" do
        expect(subject).to eq [dpetition1]
      end
    end

    describe "origin filter" do
      let(:params) { default_params.merge(origin: origin) }

      context "when filtering official dpetitions" do
        let(:origin) { "official" }

        it "returns only official dpetitions" do
          expect(subject).to eq [dpetition1]
        end
      end

      context "when filtering citizen dpetitions" do
        let(:origin) { "citizens" }

        it "returns only citizen dpetitions" do
          expect(subject).to eq [dpetition2]
        end
      end
    end

    describe "category_id" do
      context "when the given category has no subcategories" do
        let(:params) { default_params.merge(category_id: subcategory.id) }

        it "returns only dpetitions from the given category" do
          expect(subject).to eq [dpetition2]
        end
      end

      context "when the given category has some subcategories" do
        let(:params) { default_params.merge(category_id: parent_category.id) }

        it "returns dpetitions from this category and its children's" do
          expect(subject).to match_array [dpetition2, dpetition1]
        end
      end

      context "when the category does not belong to the current component" do
        let(:external_category) { create :category }
        let(:params) { default_params.merge(category_id: external_category.id) }

        it "returns an empty array" do
          expect(subject).to eq []
        end
      end
    end
  end
end
