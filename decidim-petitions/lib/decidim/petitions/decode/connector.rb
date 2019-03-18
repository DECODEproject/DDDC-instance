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

        def create
          setup_dddc_credentials
          setup_dddc_petitions
          setup_barcelona_now
        end

        def close
          close_dddc_petitions
        end

        def close_dddc_petitions
          dddc_petitions = Decidim::Petitions::Decode::Services::DDDCPetitionsAPI.new(
            Rails.application.secrets.decode[:petitions]
          )
          dddc_petitions.close(
            bearer: @petition.petition_bearer,
            petition_id: @petition.id
          )
        end

        def setup_dddc_credentials
          dddc_credentials = Decidim::Petitions::Decode::Services::DDDCCredentialIssuerAPI.new(
            Rails.application.secrets.decode[:credential_issuer]
          )
          # TODO: we should change hash_attributes and reissuable to true on production
          dddc_credentials.create(
            hash_attributes: false,
            reissuable: false,
            attribute_id: @petition.attribute_id,
            attribute_info: @petition.json_attribute_info
          )
        end

        def setup_dddc_petitions
          dddc_petitions = Decidim::Petitions::Decode::Services::DDDCPetitionsAPI.new(
            Rails.application.secrets.decode[:petitions]
          )
          dddc_petitions.create(
            petition_id: @petition.id,
            credential_issuer_url: Rails.application.secrets.decode[:credential_issuer]
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

      end
    end
  end
end
