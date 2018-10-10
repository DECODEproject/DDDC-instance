# frozen_string_literal: true

require "rqrcode"

module Decidim
  module Petitions
    module PetitionsHelper
      include Decidim::ApplicationHelper
      include Decidim::TranslationsHelper
      include Decidim::ResourceHelper

      def petition_description(petition)
        translated_attribute(petition.description)
      end

      def decodewallet_button(petition)
        link_to t("open_wallet", scope: "decidim.petitions.petitions.petition"), decode_url(petition), class: "button expanded button--sc"
      end

      def expo_button(petition)
        link_to t("open_expo", scope: "decidim.petitions.petitions.petition"), expo_url(petition), class: "button expanded button--sc"
      end

      def petition_qrcode(petition)
        "data:image/png;base64," + Base64.strict_encode64(RQRCode::QRCode.new(decode_url(petition)).as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: "white",
          color: "black",
          size: 280,
          border_modules: 4,
          module_px_size: 6,
          file: nil # path to write
        ).to_s)
      end

      def decode_url(petition)
        "decodewallet://exp.host/@decode-barcelona/decode-walletapp?release-channel=production&mobile=true&decidimAPIUrl=#{petition_url(petition.id)}"
      end

      def expo_url(petition)
        "exp://exp.host/@decode-barcelona/decode-walletapp?release-channel=production&mobile=true&decidimAPIUrl=#{petition_url(petition.id)}"
      end
    end
  end
end
