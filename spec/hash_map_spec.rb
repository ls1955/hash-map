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
    it "returns nil if key does not exist" do
      expect(subject.get(key:)).to be_nil
    end

    it "returns value if key exist" do
      subject.set(key:, val:)
      expect(subject.get(key:)).to eq val
    end
  end

  describe "#set" do
    it "sets a key value pair" do
      subject.set(key:, val:)
      expect(subject.get(key:)).to eq val
    end
  end

  describe "#key?" do
    it "returns false if key does not exist" do
      expect(subject).to_not be_key(key:)
    end

    it "returns true if key exist" do
      subject.set(key:, val:)
      expect(subject).to be_key(key:)
    end
  end

  describe "#remove" do
    it "returns nil if key does not exist" do
      expect(subject.remove(key:)).to be_nil
    end

    it "removes and returns associated value if key exist" do
      subject.set(key:, val:)
      expect(subject.remove(key:)).to eq val
    end
  end

  describe "#length" do
    it "returns the amount of key value pair" do
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
    it "removes all key value pair from self" do
      keys.zip(vals).each { |key, val| subject.set(key:, val:) }
      subject.clear
      expect(subject).to be_empty
    end
  end

  describe "#keys" do
    it "returns an array containing all the keys in unknown order" do
      keys.zip(vals).each { |key, val| subject.set(key:, val:) }
      expect(subject.keys).to match_array keys
    end
  end

  describe "#values" do
    it "returns an array containing all the values in unknown order " do
      keys.zip(vals).each { |key, val| subject.set(key:, val:) }
      expect(subject.values).to match_array vals
    end
  end

  describe "#entries" do
    it "returns an array containing all key value pair in unknown order" do
      keys.zip(vals).each { |key, val| subject.set(key:, val:) }
      expect(subject.entries).to match_array keys.zip(vals)
    end
  end

  describe "#capacity" do
    it "by default is 16" do
      expect(subject.capacity).to eq 16
    end

    it "changes if given initial_capacities" do
      initial_capacity = 24
      subject = described_class.new(initial_capacity:)
      expect(subject.capacity).to eq initial_capacity
    end

    it "grows if exceed load factor" do
      initial_capacity = subject.capacity
      [*"a".."z"].each_with_index { |key, val| subject.set(key:, val:) }
      expect(subject.capacity).to be >= initial_capacity
    end
  end
end
# rubocop:enable Metrics/BlockLength
