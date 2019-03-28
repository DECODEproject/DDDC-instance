# frozen_string_literal: true

require 'decidim/petitions/decode/services/dddc_credential_issuer_api'
require 'decidim/petitions/decode/services/dddc_petitions_api'
require 'decidim/petitions/decode/services/barcelona_now'

module Decidim
  module Petitions
    module Decode
      class Connector

        def initialize(petition)
          @petition = petition
        end

        def setup_dddc_credentials
          dddc_credentials = Decidim::Petitions::Decode::Services::DDDCCredentialIssuerAPI.new(
            Rails.application.secrets.decode[:credential_issuer]
          )
          dddc_credentials.create(
            hash_attributes: true,
            reissuable: @petition.is_reissuable,
            attribute_id: @petition.attribute_id,
            attribute_info: @petition.json_attribute_info,
            attribute_info_optional: @petition.json_attribute_info_optional
          )
        end

        def setup_barcelona_now
          barcelona_now = Decidim::Petitions::Decode::Services::BarcelonaNow.new(
            Rails.application.secrets.decode[:barcelona_now_dashboard]
          )
          barcelona_now.create(
            credential_issuer_url: Rails.application.secrets.decode[:credential_issuer][:url],
            community_name: @petition.community_name,
            community_id: @petition.community_id,
            attribute_id: @petition.attribute_id
          )
        end

        def setup_dddc_petitions
          dddc_petitions = Decidim::Petitions::Decode::Services::DDDCPetitionsAPI.new(
            Rails.application.secrets.decode[:petitions]
          )
          dddc_credentials = Decidim::Petitions::Decode::Services::DDDCCredentialIssuerAPI.new(
            Rails.application.secrets.decode[:credential_issuer]
          )
          attribute_info = dddc_credentials.extract_first_attribute_info(@petition.json_attribute_info)
          dddc_petitions.create(
            petition_id: @petition.attribute_id,
            credential_issuer_url: Rails.application.secrets.decode[:credential_issuer][:url],
            credential_issuer_petition_value: attribute_info

          )
        end

        def get_dddc_petitions
          dddc_petitions = Decidim::Petitions::Decode::Services::DDDCPetitionsAPI.new(
            Rails.application.secrets.decode[:petitions]
          )
          dddc_petitions.get(
            petition_id: @petition.attribute_id
          )
        end

        def tally_dddc_petitions
          dddc_petitions = Decidim::Petitions::Decode::Services::DDDCPetitionsAPI.new(
            Rails.application.secrets.decode[:petitions]
          )
          dddc_petitions.tally(
            petition_id: @petition.attribute_id
          )
        end

        def count_dddc_petitions
          dddc_petitions = Decidim::Petitions::Decode::Services::DDDCPetitionsAPI.new(
            Rails.application.secrets.decode[:petitions]
          )
          dddc_petitions.count(
            petition_id: @petition.attribute_id
          )
        end

        def assert_count_dddc_petitions
          api_result = get_dddc_petitions
          json_result = JSON.parse(api_result[:response])
          Decidim::Petitions::Decode::Zenroom.count_petition(
            json_tally: json_result["tally"],
            json_petition: json_result["petition"],
          )
        end

      end
    end
  end
end
