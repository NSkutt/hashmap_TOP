# frozen_string_literal: true

# This line will be used when buckets are accesed by index

# TOP Project HashMap
class HashMap
  def initialize
    @buckets = Array.new(16)
    @load_factor = 0.75
  end

  def growth_check
    return unless keys.length >= @load_factor * @buckets.length

    temp_array = entries
    @buckets = Array.new(@buckets.length * 2)

    temp_array.each { |kv| set(kv.first, kv[1]) }
  end

  def bucket_check; p @buckets; end

  def checkout(key)
    index = hash(key)
    raise IndexError if index.negative? || index >= @buckets.length

    index
  end

  def hash(str)
    hash_code = 0
    prime_num = 31
    str.each_char { |char| prime_num * hash_code += char.ord }
    index = hash_code % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    index
  end

  def set(key, val)
    idx = checkout(key)
    @buckets[idx] = [key, val, @buckets[idx]]
    growth_check
  end

  def get(key)
    idx = checkout(key)
    @buckets[idx][1]
  end

  def key?(key)
    idx = checkout(key)
    return false if @buckets[idx].nil?

    @buckets[idx].flatten.include?(key)
  end

  def remove(key)
    idx = checkout(key)
    nil unless key?(key)


  end

  def length
    filled_buckets = 0
    @buckets.each { |bucket| bucket.nil? ? next : filled_buckets += 1 }
    filled_buckets
  end

  def clear
    @buckets.map! { nil }
    @buckets = Array.new(16)
  end

  def keys(arr = @buckets, keychain = [])
    keychain.push(arr.first) unless arr.first.nil?
    arr.each do |bucket|
      keys(bucket, keychain) if bucket.is_a?(Array)
    end
    keychain
  end

  def values(arr = @buckets, lockbox = [])
    lockbox.push(arr[1]) unless arr.first.nil?
    arr.each do |bucket|
      values(bucket, lockbox) if bucket.is_a?(Array)
    end
    lockbox
  end

  def entries(arr = @buckets, log = [])
    log.push([arr.first, arr[1]]) unless arr.first.nil?
    arr.each do |bucket|
      entries(bucket, log) if bucket.is_a?(Array)
    end
    log
  end
end
