# frozen_string_literal: true
#
require "decidim/petitions/decode/zenroom"
require "decidim/petitions/decode/rest_api"

module Decidim
  module Petitions
    module Decode
      module Services
        class DDDCCredentialIssuerAPI
          # Integration with https://github.com/DECODEproject/dddc-credential-issuer

          include RestApi

          def initialize login
            # login needs to be a hash with url, username and password
            # login = { url: "http://example.com", username: "demo", password: "demo"}
            @login = login
          end

          def create(hash_attributes: false, reissuable: false, attribute_id: '', attribute_info: '')
            # Setup the Authorizable Attribute to Credential Issuer's API
            # If hash_attributes is true, then we hash the attribute_info with zenroom
            # If reissuable is true, then we send that configuration to Credential Issuer
            #
            url = @login[:url]
            bearer = get_bearer( url: url, username: @login[:username], password: @login[:password])
            attribute_info = hash_attributes ? hash_attribute_info(attribute_info) : attribute_info
            params = { authorizable_attribute_id: "Authorizable Attribute #{attribute_id}",
                       authorizable_attribute_info: attribute_info,
                       reissuable: reissuable }
            wrapper(http_method: :post, http_path: "#{url}/authorizable_attribute", params: params, bearer: bearer)
          end

          def hash_attribute_info attribute_info
            # Recieves an attribute info with value_sets on plain text
            # and converts them with a hashing function from zenroom
            #
            logger "Credential issuer set-up - Authorizable attribute to hash"
            logger attribute_info
            output = []
            attribute_info.each do |attribute|
              hashes = []
              attribute["value_set"].each do |x|
                hashes << Decidim::Petitions::Decode::Zenroom.hashing(x)
              end
              attribute["value_set"] = hashes
              output << attribute
            end

            logger "Credential issuer set-up - Authorizable attribute hashed"
            logger output
            output
          end

        end
      end
    end
  end
end
