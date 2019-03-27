# frozen_string_literal: true
#

require "decidim/petitions/decode/file_logger"

module Decidim
  module Petitions
    module Decode
      class Zenroom

        extend FileLogger

        CONTRACTS_DIR = "#{File.dirname(__FILE__)}/dddc-pilot-contracts"
        ZENROOM = "#{Rails.root}/bin/zenroom-static"

        def self.hashing data
          # Hashes with zenroom some data. For having better privacy with Credential Issuer.
          #
          `echo "print(ECDH.kdf(HASH.new('sha512'), str('#{data}')))" | #{ZENROOM} 2> /dev/null`.strip
        end

        def self.write_to_tmp_file(filename, contents)
          filepath = "#{Rails.root.join('tmp')}/#{filename}"
          f = File.new(filepath, 'w')
          f << contents
          f.close
          filepath
        end

        def self.count_petition(json_tally: '', json_petition: '')
          # Counts the petition given a tally.json and petition.json with the contract
          # from DECODE's dddc-pilot-contracts.
          #
          # FIXME: it shouldn't be the same tally / petition for all the petitions
          contract="#{CONTRACTS_DIR}/14-CITIZEN-count-petition.zencode"
          tally_file_path = write_to_tmp_file("tally.json", JSON.unparse(json_tally))
          petition_file_path = write_to_tmp_file("petition.json", JSON.unparse(json_petition))
          logger("*" * 80)
          logger "ASSERT COUNT WITH ZENROOM"
          logger "TALLY    => #{json_tally}"
          logger "PETITION => #{json_petition}"
          `#{ZENROOM} -k #{tally_file_path}  -a #{petition_file_path} -z #{contract} 2> /dev/null`.strip
        end

      end
    end
  end
end
