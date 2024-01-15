# frozen_string_literal: false

require "debug"

require_relative "../src/hash_set"

# rubocop:disable Metrics/BlockLength
RSpec.describe HashSet do
  let(:val) { "kuma" }
  let(:vals) { %w[burger sandwich ham] }

  describe "#get" do
    it "returns nil if value does not exist" do
      expect(subject.get(val:)).to be_nil
    end

    it "returns value if it exist" do
      subject.add(val:)
      expect(subject.get(val:)).to eq val
    end
  end

  describe "#add" do
    it "adds value into itself" do
      subject.add(val:)
      expect(subject).to be_include(val:)
    end
  end

  describe "#delete" do
    it "returns nil if value does not exist" do
      expect(subject.delete(val:)).to be_nil
    end

    it "deletes and returns value if value exist" do
      subject.add(val:)
      expect(subject.delete(val:)).to eq val
    end
  end

  describe "#length" do
    it "returns its own length" do
      vals.each { |val| subject.add(val:) }
      expect(subject.length).to eq vals.length
    end
  end
end
# rubocop:enable Metrics/BlockLength
