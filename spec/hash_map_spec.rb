# frozen_string_literal: false

require "debug"

require_relative "../src/hash_map"

# rubocop:disable Metrics/BlockLength
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

  describe "#empty?" do
    it "returns false if there are key value pair" do
      subject.set(key:, val:)
      expect(subject).to_not be_empty
    end

    it "returns true if there are no key value pair" do
      expect(subject).to be_empty
    end
  end

  describe "#clear" do
    it "could removes all key value pair from self" do
      keys.zip(vals).each { |key, val| subject.set(key:, val:) }
      subject.clear
      expect(subject).to be_empty
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

  describe "#capacity" do
    it "by default have a capacity of 16" do
      expect(subject.capacity).to eq 16
    end

    it "could be given initial capacity" do
      initial_capacity = 24
      subject = described_class.new(initial_capacity:)
      expect(subject.capacity).to eq initial_capacity
    end

    it "grows if capacity if exceed own load factor" do
      initial_capacity = subject.capacity
      [*"a".."z"].each_with_index { |key, val| subject.set(key:, val:) }
      expect(subject.capacity).to be >= initial_capacity
    end
  end
end
# rubocop:enable Metrics/BlockLength
