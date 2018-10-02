module Decidim
  module Petitions
    class Petition < Petitions::ApplicationRecord
      include Decidim::Authorable
      include Decidim::HasComponent
      include Decidim::Publicable
      include Decidim::Resourceable

      def body
        title
      end
    end
  end
end
