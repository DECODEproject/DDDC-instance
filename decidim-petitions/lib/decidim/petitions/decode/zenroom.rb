# frozen_string_literal: true


module Decidim
  module Petitions
    module Decode
      class Zenroom

        def self.hashing data
          # Hashes with zenroom some data. For having better privacy with Credential Issuer.
          #
          `echo "print(ECDH.kdf(HASH.new('sha512'), '#{data}'))" | ./bin/zenroom-static 2> /dev/null`.strip
        end

      end
    end
  end
end
