module Decidim
  module Petitions
    class Petition < Petitions::ApplicationRecord
      include Decidim::Authorable
      include Decidim::HasComponent
      include Decidim::Publicable
      include Decidim::Resourceable

      mount_uploader :image, Decidim::Petitions::ImageUploader

      def body
        title
      end

      def community_id
        title
      end

      def attribute_id
        Decidim.config.application_name.downcase.gsub(' ', '-') + "-" + id.to_s
      end

      scope :closed, -> { where(state: "closed") }
      scope :opened, -> { where(state: "opened") }

      def closed?
        state == "closed"
      end

      def opened?
        state == "opened"
      end
    end
  end
end
