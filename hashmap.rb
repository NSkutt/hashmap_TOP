# frozen_string_literal: true

# This line will be used when buckets are accesed by index
# raise IndexError if index.negative? || index >= @buckets.length

# TOP Project HashMap
class HashMap
  def initialize
    @buckets = Array.new(16)
    @load_factor = 0.75
    @old_length = @buckets.length
  end

  def grow
    @buckets += Array.new(@buckets.length) if hash.length >= @load_factor * @buckets.length
  end

  def hash(str)
    hash_code = 0
    string.each_char { |char| hash_code += char.ord }
    set(hash_code, str)
  end

  def set(k, val)
    place = k % @buckets.length
    @buckets[place] = [val, @buckets[place]]
  end

  def get

  end

  def key?

  end

  def remove

  end

  def length

  end

  def clear

  end

  def keys

  end

  def values

  end

  def entries

  end
end
