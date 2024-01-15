# frozen_string_literal: false

require "debug"
require "forwardable"

require_relative "hash_map"

# :nodoc:
class HashSet
  extend Forwardable

  def initialize
    @hash = HashMap.new
  end

  def_delegators :@hash, :clear, :empty?, :length

  def add(val:) = @hash.set(key: val, val: true)

  def get(val:) = (val if include?(val:))

  def include?(val:) = @hash.key?(key: val)
  
  def delete(val:)
    return nil unless include?(val:)

    @hash.remove(key: val)
    val
  end
end
