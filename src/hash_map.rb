# frozen_string_literal: false

require "debug"

# :nodoc:
class HashMap
  attr_reader :capacity

  def initialize(initial_capacity: 16)
    @buckets = Array.new(initial_capacity)
    @capacity = initial_capacity
  end

  def get(key:)
    index = index(key)

    return nil unless @buckets[index]

    @buckets[index].each_node.find { _1.key == key }&.val
  end

  def set(key:, val:)
    index = index(key)

    return @buckets[index] = Node.new(key:, val:) unless @buckets[index]

    node = @buckets[index].each_node.find { _1.key == key }
    node ? node.val = val : @buckets[index] = Node.new(key:, val:, next: @buckets[index])

    # TODO: adjust_bucket_size_if_required
  end

  def key?(key:) = !!get(key:)

  def remove(key:)
    index = index(key)

    return nil unless @buckets[index]
    return @buckets[index].val.tap { @buckets[index] = nil } if @buckets[index].size == 1

    @buckets[index].delete_first_if { |node| node.key == key }&.val

    # TODO: adjust_bucket_size_if_required
  end

  def length = @buckets.compact.sum(&:size)

  def clear = @buckets.clear

  def keys = @buckets.compact.flat_map { |node| node.each_node.collect(&:key) }

  def values = @buckets.compact.flat_map { |node| node.each_node.collect(&:val) }

  def entries = keys.zip(values)

  private

  Node = Struct.new(:key, :val, :next) do
    def each_node
      return to_enum(__method__) unless block_given?

      curr = self

      while curr
        yield curr
        curr = curr.next
      end
    end

    def size = each_node.count

    # Returns first deleted node if given block yield true, else nil.
    # Connects rest of the list automatically.
    def delete_first_if
      each_node do |node|
        break unless node.next
        next unless yield node.next

        return node.next.tap { node.next = node.next.next }
      end
    end
  end

  def index(str) = hash(str) % capacity

  # A random prime number use in generate hash.
  PRIME_NUM = 31

  # Returns a hash (Integer) from *str*.
  def hash(str)
    str.each_char.reduce(0) { |result, char| PRIME_NUM * result + char.ord }
  end

  LOAD_FACTOR = 0.75

  def adjust_bucket_size
    # TODO
  end
end
