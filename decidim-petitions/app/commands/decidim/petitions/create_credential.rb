# frozen_string_literal: true

require "rest-client"

module Decidim
  module Petitions
    class CreateCredential < Rectify::Command
      def initialize(form)
        @form = form
      end

      def call
        brodcast(:invalid) if @form.invalid?

        transaction do
          create_credential!
        end
      end

      private

      def create_credential!
        return broadcast(:invalid) if @form.invalid?
        begin
          response = RestClient.post(Rails.application.secrets.decode[:credential_issuer_url], dni: @form.dni)
        rescue RestClient::ExceptionWithResponse => e
          response = e.response
        end
        case response.code
        when 200
          broadcast(:ok, JSON.parse(response.body))
        else
          broadcast(:error)
        end
      end
    end
  end
end
