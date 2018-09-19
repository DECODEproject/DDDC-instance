# frozen_string_literal: true

module Decidim
  module Dpetitions
    # Exposes the dpetition resource so users can view them
    class DpetitionsController < Decidim::Dpetitions::ApplicationController
      helper Decidim::ApplicationHelper
      helper Decidim::Messaging::ConversationHelper
      include FormFactory
      include FilterResource
      include Paginable

      helper_method :dpetitions, :dpetition, :paginated_dpetitions, :report_form

      def new
        enforce_permission_to :create, :dpetition

        @form = form(DpetitionForm).instance
      end

      def create
        enforce_permission_to :create, :dpetition

        @form = form(DpetitionForm).from_params(params, current_component: current_component)

        CreateDpetition.call(@form) do
          on(:ok) do |dpetition|
            flash[:notice] = I18n.t("dpetitions.create.success", scope: "decidim.dpetitions")
            redirect_to Decidim::ResourceLocatorPresenter.new(dpetition).path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("dpetitions.create.invalid", scope: "decidim.dpetitions")
            render action: "new"
          end
        end
      end

      private

      def paginated_dpetitions
        @paginated_dpetitions ||= paginate(dpetitions)
                               .includes(:category)
      end

      def dpetitions
        @dpetitions ||= search.results
      end

      def dpetition
        @dpetition ||= dpetitions.find(params[:id])
      end

      def report_form
        @report_form ||= form(Decidim::ReportForm).from_params(reason: "spam")
      end

      def search_klass
        DpetitionSearch
      end

      def default_search_params
        {
          page: params[:page],
          per_page: 12
        }
      end

      def default_filter_params
        {
          search_text: "",
          order_start_time: "asc",
          origin: "all",
          category_id: ""
        }
      end
    end
  end
end
