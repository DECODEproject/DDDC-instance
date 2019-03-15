# frozen_string_literal: true

require "decidim/petitions/decode/services/dddc_credential_issuer_api"

describe Decidim::Petitions::Decode::Services::DDDCCredentialIssuerAPI do

  context "should create work" do

    it "should .create work" do
      # TODO implement
    end

    it "should .hash_attribute_info work" do
      dddc_credentials = Decidim::Petitions::Decode::Services::DDDCCredentialIssuerAPI.new("http://credentials.example.com")
      input = [
        {
          "name": "email",
          "type": "str",
          "value_set": [
            "andres@example.com"
          ]
        }, {
          "name": "zip_code",
          "type": "int",
          "value_set": [
            "08001",
            "08002"
          ]
        }
      ]
      output = [
        {
          :name=>"email",
          :type=>"str",
          :value_set=>[
            "06bef662965b97a2a6ee233b89d3f22ce55a1cc9ac0b6d08c2951d6f30c7e59c1a54bcfb67ae87330c28a3834ce4b12e5b828fcb88742321ddad4dad81b9e036"
          ]
        }, {
          :name=>"zip_code",
          :type=>"int",
          :value_set=>[
            "ae9c05449e6643e5e7630d7e69985d1882aac405e03cbb8b4bf580b59fa7e744eec3cf2983301d3ec9c9610cfa1eb0daecc4b95e6cb392ee27f66c870eb49236",
            "6285f7542a8851fe6249ad0888222b1dd66c5f0f8a53e9199c99b8dcbc4a0935ee4c754319746cd85d105cc684062590a4769aab2a2badd11c5f42bea24cacd4"
          ]
        }
      ]
      result = dddc_credentials.hash_attribute_info input
      expect(result).to eq output
    end

  end
end
