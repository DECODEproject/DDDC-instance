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
        link_to t('open_wallet', scope: 'decidim.petitions.petitions.petition'), "#", class: "button expanded button--sc" 
      end

      def petition_qrcode(petition)
        url = "decodewallet://exp.host/@decode-barcelona/decode-walletapp?release-channel=produciton&mobile=true&petitionLink=#{petition_url(petition.id)}"
        'data:image/png;base64,' + Base64.strict_encode64(RQRCode::QRCode.new(url).as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: 280,
          border_modules: 4,
          module_px_size: 6,
          file: nil # path to write
          ).to_s)
      end
    end
  end
end
