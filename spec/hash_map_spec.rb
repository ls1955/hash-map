# frozen_string_literal: false

require "debug"

require_relative "../src/hash_map"

RSpec.describe HashMap do
  let(:key) { "tuna" }
  let(:val) { "kuma" }
  let(:keys) { %w[bonito potato yam] }
  let(:vals) { %w[burger sandwich ham] }

  describe "#get" do
    it "return nil if key does not exist" do
      expect(subject.get(key:)).to be_nil
    end

    it "return value if key exist" do
      subject.set(key:, val:)
      expect(subject.get(key:)).to eq val
    end
  end

  describe "#set" do
    it "could set a key value pair" do
      subject.set(key:, val:)
      expect(subject.get(key:)).to eq val
    end
  end

  describe "#key?" do
    it "return false if key does not exist" do
      expect(subject).to_not be_key(key:)
    end

    it "return true if key exist" do
      subject.set(key:, val:)
      expect(subject).to be_key(key:)
    end
  end

  describe "#remove" do
    it "return nil if key does not exist" do
      expect(subject.remove(key:)).to be_nil
    end

    it "remove and return associated value if key exist" do
      subject.set(key:, val:)
      expect(subject.remove(key:)).to eq val
    end
  end

  describe "#length" do
    it "could return the amount of key value pair" do
      keys.zip(vals).each { |key, val| subject.set(key:, val:) }
      expect(subject.length).to eq keys.size
    end
  end

  describe "#clear" do
    it "could removes all key value pair from self" do
      keys.zip(vals).each { |key, val| subject.set(key:, val:) }
      subject.clear
      keys.each { |key| expect(subject.get(key:)).to be_nil }
    end
  end

  describe "#keys" do
    it "could return an array containing all the keys in unknown order" do
      keys.zip(vals).each { |key, val| subject.set(key:, val:) }
      expect(subject.keys).to match_array keys
    end
  end

  describe "#values" do
    it "could return an array containing all the values in unknown order " do
      keys.zip(vals).each { |key, val| subject.set(key:, val:) }
      expect(subject.values).to match_array vals
    end
  end

  describe "#entries" do
    it "could return an array containing all key value pair in unknown order" do
      keys.zip(vals).each { |key, val| subject.set(key:, val:) }
      expect(subject.entries).to match_array keys.zip(vals)
    end
  end
end
