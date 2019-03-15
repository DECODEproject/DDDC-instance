# frozen_string_literal: true

if false
  require "decidim/petitions/test/factories"
  require "factory_bot"
  require "webmock/rspec"
  require "decidim/petitions/decode/services/barcelona_now"

  describe Decidim::Petitions::Decode::Services::BarcelonaNow do

    before :all do
      stub_request(:any, "http://barcelonanow.example.com")
      @petition = FactoryBot.create :petitions_component
    end

    context "should create work" do

      it "should make the post to the API" do
        Decidim::Petitions::Decode::Services::BarcelonaNow.new(@petition).create
        #expect(result).to_not eq "bla"
      end

    end
  end
end
