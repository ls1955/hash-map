# frozen_string_literal: false

require "debug"

# :nodoc:
class HashMap
  attr_reader :capacity, :length

  def initialize(initial_capacity: 16)
    @buckets = Array.new(initial_capacity)
    @capacity = initial_capacity
    @length = 0
  end

  def get(key:)
    index = index(key)

    return nil unless @buckets[index]

    @buckets[index].each_node.find { _1.key == key }&.val
  end

  def set(key:, val:)
    index = index(key)
    @length += 1

    return @buckets[index] = Node.new(key:, val:) unless @buckets[index]

    node = @buckets[index].each_node.find { _1.key == key }
    node ? node.val = val : @buckets[index] = Node.new(key:, val:, next: @buckets[index])

    # TODO: adjust_bucket_size_if_required
  end

  def key?(key:) = !!get(key:)

  def remove(key:)
    index = index(key)

    return nil unless @buckets[index]

    if @buckets[index].size == 1
      @length -= 1
      return @buckets[index].val.tap { @buckets[index] = nil }
    end

    has_delete = @buckets[index].delete_first_if { |node| node.key == key }&.val
    @length -= 1 if has_delete

    enlarge_buckets_if_require
  end

  def empty? = length.zero?

  def clear
    @buckets.clear
    @length = 0
  end

  def keys = @buckets.compact.flat_map { |node| node.each_node.collect(&:key) }

  def values = @buckets.compact.flat_map { |node| node.each_node.collect(&:val) }

  def entries
    @buckets.compact.map { |node| node.each_node.collect { [_1.key, _1.val] } }.flatten(1)
  end

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

        return node.next.tap { node.next = node.next.next } if yield node.next
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
