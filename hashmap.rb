# frozen_string_literal: true

# This line will be used when buckets are accesed by index

# TOP Project HashMap
class HashMap
  def initialize
    @buckets = Array.new(16)
    @load_factor = 0.75
  end

  def growth_check
    if hash.length >= @load_factor * @buckets.length
      @buckets += Array.new(@buckets.length)

    end
  end

  def error_check(index)
    raise IndexError if index.negative? || index >= @buckets.length
  end

  def hash(str)
    hash_code = 0
    prime_num = 31
    str.each_char { |char| prime_num * hash_code += char.ord }
    hash_code % @buckets.length
    error_check(hash_code)
    hash_code
  end

  def set(k, val)
    idx = hash(k)

    @buckets[idx] = [k, val, @buckets[idx]]
    growth_check
  end

  def get(key)
    idx = hash(key)
    error_check(idx)
    @buckets[idx][1]
  end

  def key?(key)
    idx = hash(key)
    error_check(idx)
    @buckets[idx].flatten.include?(key)
  end

  def remove(key)
    idx = hash(key)
    error_check(idx)
    key?(key) ? @buckets.delete_at(idx) : nil
  end

  def length
    filled_buckets = 0
    @buckets.for_each { |bucket| bucket.nil? ? next : filled_buckets += 1 }
    filled_buckets
  end

  def clear
    @buckets.each { |bucket| bucket = nil}
    @buckets = Array.new(16)
  end

  def keys(arr = @buckets, keychain = [])
    return if arr.first.nil?

    keychain.push(arr.first)
    arr.each do |bucket|
      keys(bucket, keychain) if bucket.is_a?(Array)
    end
    keychain
  end

  def values

  end

  def entries

  end
end
