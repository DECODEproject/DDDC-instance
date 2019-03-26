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

          def create(hash_attributes: false,
                     reissuable: false,
                     attribute_id: '',
                     attribute_info: '',
                     attribute_info_optional: ''
                    )
            # Setup the Authorizable Attribute to Credential Issuer's API
            # If hash_attributes is true, then we hash the attribute_info with zenroom
            # If reissuable is true, then we send that configuration to Credential Issuer
            #
            url = @login[:url]
            bearer = get_bearer( url: url, username: @login[:username], password: @login[:password])
            attribute_info = hash_attributes ? hash_attribute_info(attribute_info) : attribute_info
            attribute_info_optional = hash_attributes ? hash_attribute_info(attribute_info_optional) : attribute_info_optional
            params = { authorizable_attribute_id: attribute_id,
                       authorizable_attribute_info: attribute_info,
                       authorizable_attribute_info_optional: attribute_info_optional,
                       reissuable: reissuable }
            wrapper(http_method: :post, http_path: "#{url}/authorizable_attribute/", params: params, bearer: bearer)
          end

          def hash_attribute_info attribute_info
            # Recieves an attribute info with value_sets on plain text
            # and converts them with a hashing function from zenroom
            #
            logger "*" * 80
            logger "ATTR TO HASH => #{attribute_info} "
            output = []
            attribute_info.each do |attribute|
              hashes = []
              attribute["value_set"].each do |x|
                hashes << Decidim::Petitions::Decode::Zenroom.hashing(x)
              end
              attribute["value_set"] = hashes
              output << attribute
            end
            logger "ATTR HASHED  => #{output} "
            logger "*" * 80
            output
          end

          def extract_first_attribute_info attribute_info
            # Given an attribute_info we delete all the value_sets except the first one (that's also hashed)
            # for being use with Petition API setup
            # input = [{"name"=>"codes", "type"=>"str", "value_set"=>["aaaaa", "bbbbb", "ccccc"]}]
            # output = [{"name"=>"codes", "type"=>"str", "value_set"=>["aaaaa"}]
            #
            logger "*" * 80
            logger "ATTR TO EXTRACT  => #{attribute_info} "
            attribute_info.each do |attribute|
              attribute["value"] = Decidim::Petitions::Decode::Zenroom.hashing(attribute["value_set"][0])
              attribute.except!("type", "value_set")
            end
            attribute_info
            logger "ATTR EXTRACTED  => #{attribute_info} "
            logger "*" * 80
            attribute_info
          end

        end
      end
    end
  end
end
