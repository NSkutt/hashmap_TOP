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
    @buckets += Array.new(@buckets.length)
    temp_array.each_slice(2) { |kv| set(kv.first, kv[1]) }
  end

  def bucket_check; p @buckets; end

  def error_check(index)
    raise IndexError if index.negative? || index >= @buckets.length
  end

  def hash(str)
    hash_code = 0
    prime_num = 31
    str.each_char { |char| prime_num * hash_code += char.ord }
    hash_code %= @buckets.length
    error_check(hash_code)
    hash_code
  end

  def set(key, val)
    idx = hash(key)

    @buckets[idx] = [key, val, @buckets[idx]]
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
    @buckets.each { |bucket| bucket.nil? ? next : filled_buckets += 1 }
    filled_buckets
  end

  def clear
    @buckets.map! { |bucket| bucket = nil}
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
