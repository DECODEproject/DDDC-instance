# frozen_string_literal: true

module Decidim
  module Petitions
    class ImageUploader < Decidim::ImageUploader
      version :wide do
        process resize_to_fit: [600, 160]
      end

      version :square do
        process resize_to_fit: [120, 120]
      end
    end
  end
end
