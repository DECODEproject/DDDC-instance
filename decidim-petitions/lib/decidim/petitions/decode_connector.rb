# frozen_string_literal: true


module Decidim
  module Petitions
    class DecodeConnector
      def initialize(petition)
        @petition = petition
        @credential_issuer = Rails.application.secrets.decode[:credential_issuer]
        @barcelona_now = Rails.application.secrets.decode[:barcelona_now_dashboard]
      end

      def main
        setup_credential_issuer
        setup_barcelona_now_dashboard
      end

      def logger message
        if defined? Rails
          require 'logger'
          Rails.logger.info message
        else
          puts message
        end
      end

      def get_credential_issuer_bearer
        # Gets Credential Issuer's API bearer to have an Authorization
        #
        logger "Credential issuer set-up - Bearer"
        resp = RestClient.post(
          "#{@credential_issuer[:url]}/token",
          {grant_type: "", username: @credential_issuer[:username], password: @credential_issuer[:password]}
        )
        bearer = JSON.parse(resp.body)["access_token"]
        logger bearer
        bearer
      end

      def setup_credential_issuer
        # Setup the Authorizable Attribute to Credential Issuer's API
        # TODO: change reissuable to false on prod
        #
        logger "Credential issuer set-up - Authorizable Attribute #{@petition.attribute_id}"
        bearer = get_credential_issuer_bearer
        resp = RestClient.post(
          "#{@credential_issuer[:url]}/authorizable_attribute",
          {
            authorizable_attribute_id: "Authorizable Attribute #{@petition.attribute_id}",
            authorizable_attribute_info: hash_attribute_info(@petition.json_attribute_info),
            reissuable: true
          }.to_json,
          { authorization: "Bearer #{bearer}", content_type: :json, accept: :json }
        )
        logger JSON.parse(resp.body)
        logger "Credential issuer set-up - all OK"
      end

      def hash_with_zenroom data
        # Hashes with zenroom some data. For having better privacy with Credential Issuer.
        #
        `echo "print(ECDH.kdf(HASH.new('sha512'), '#{data}'))" | ./bin/zenroom-static`
      end

      def hash_attribute_info attribute_info
        # Given some attribute_info, hashes the value_sets inside)
        # TODO: implement
        #
        logger "Credential issuer set-up - Authorizable attribute to hash"
        logger attribute_info
        logger "Credential issuer set-up - Authorizable attribute hashed"
        logger attribute_info
        attribute_info
      end

      def setup_barcelona_now_dashboard
        # Setup the Barcelona Now Dashboard API
        #
        logger "Barcelona NOW Dashboard set-up - Initializing"
        resp = RestClient.post(
          "#{@barcelona_now[:url]}/community/create_encrypted",
          {
            community_name: @petition.title,
            community_id: @petition.community_id,
            authorizable_attribute_id: @petition.attribute_id,
            credential_issuer_endpoint_address: @credential_issuer[:url]
          }.to_json,
          {content_type: :json, accept: :json}
        )
        logger JSON.parse(resp.body)
        logger "Barcelona NOW Dashboard set-up - all OK"
      end
    end
  end
end
