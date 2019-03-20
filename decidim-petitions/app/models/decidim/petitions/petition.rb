module Decidim
  module Petitions
    class Petition < Petitions::ApplicationRecord
      include Decidim::Authorable
      include Decidim::HasComponent
      include Decidim::Publicable
      include Decidim::Resourceable

      mount_uploader :image, Decidim::Petitions::ImageUploader

      scope :closed, -> { where(state: "closed") }
      scope :opened, -> { where(state: "opened") }

      def body
        title
      end

      def community_name
        title["en"]
      end

      def community_id
        SecureRandom.hex(20)
      end

      def attribute_id
        (Decidim.config.application_name + "-" + title["en"]).downcase.gsub(' ', '-')
      end

      def closed?
        state == "closed"
      end

      def opened?
        state == "opened"
      end
    end
  end
end
