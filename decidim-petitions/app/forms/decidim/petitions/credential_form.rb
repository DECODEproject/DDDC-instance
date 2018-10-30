# frozen_string_literal: true

module Decidim
  module Petitions
    class CredentialForm < Form
      attribute :dni
      attribute :linked_uri
    end
  end
end
