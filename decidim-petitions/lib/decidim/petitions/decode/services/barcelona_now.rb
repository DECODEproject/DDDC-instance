# frozen_string_literal: true

require "decidim/petitions/decode/rest_api"

module Decidim
  module Petitions
    module Decode
      module Services
        class BarcelonaNow
          # Integration with https://github.com/DECODEproject/bcnnow

          include RestApi

          def initialize login
            # login needs to be a hash with url
            # login = { url: "http://example.com" }
            @login = login
          end

          def create(credential_issuer_url: '', community_name: '', community_id: '', attribute_id: '')
            # Setup the Barcelona Now Dashboard API
            #
            params = { community_name: community_name,
                       community_id: community_id,
                       authorizable_attribute_id: attribute_id,
                       credential_issuer_endpoint_address: credential_issuer_url }
            wrapper(http_method: :post, http_path: "#{@login[:url]}/community/create_encrypted", params: params)
          end

        end
      end
    end
  end
end
