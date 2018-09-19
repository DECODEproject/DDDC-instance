# frozen_string_literal: true

module Decidim
  module Dpetitions
    # This class handles search and filtering of dpetitions. Needs a
    # `current_component` param with a `Decidim::Component` in order to
    # find the dpetitions.
    class DpetitionSearch < ResourceSearch
      # Public: Initializes the service.
      # component     - A Decidim::Component to get the dpetitions from.
      # page        - The page number to paginate the results.
      # per_page    - The number of proposals to return per page.
      def initialize(options = {})
        super(Dpetition.not_hidden, options)
      end

      # Handle the search_text filter. We have to cast the JSONB columns
      # into a `text` type so that we can search.
      def search_search_text
        query
          .where("title::text ILIKE ?", "%#{search_text}%")
          .or(query.where("description::text ILIKE ?", "%#{search_text}%"))
      end

      # Handle the origin filter
      # The 'official' dpetitions don't have an author ID
      def search_origin
        if origin == "official"
          query.where(decidim_author_id: nil)
        elsif origin == "citizens"
          query.where.not(decidim_author_id: nil)
        else # Assume 'all'
          query
        end
      end
    end
  end
end
