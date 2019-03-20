# frozen_string_literal: true


require 'decidim/petitions/decode/zenroom'

describe Decidim::Petitions::Decode::Zenroom do

  context "should hashing work" do

    it "should give the correct hash" do
      result = Decidim::Petitions::Decode::Zenroom.hashing("hello world")
      expect(result).to eq "d33c2600e0b033669058e8ef39962bc21db40c2b1884b497df094e96a25aea9ed04c40d6408fc1eb5bc6e9bf131cd7bf117b2e6ae2450db7b7f88202849536de"
    end

    it "should not give an incorrect hash" do
      result = Decidim::Petitions::Decode::Zenroom.hashing("invalid")
      expect(result).to_not eq "d33c2600e0b033669058e8ef39962bc21db40c2b1884b497df094e96a25aea9ed04c40d6408fc1eb5bc6e9bf131cd7bf117b2e6ae2450db7b7f88202849536de"
    end

  end
end
