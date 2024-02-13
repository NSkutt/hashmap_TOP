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

  def bucket_check; @buckets; end

  def checkout(key)
    index = hash(key)
    raise IndexError if index.negative? || index >= @buckets.length

    index
  end

  def hash(str)
    hash_code = 0
    prime_num = 31
    str.each_char { |char| prime_num * hash_code += char.ord - 1 }
    index = hash_code % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    index
  end

  def compactor(idx)
    @buckets[idx].compact! if @buckets[idx].is_a?(Array)
    @buckets.each { |item| item.is_a?(Array) ? item.compact! : next }
  end

  def set(key, val)
    idx = checkout(key)
    @buckets[idx] = if key?(key)
                      reassign(key, val, @buckets[idx])
                    else
                      [key, val, @buckets[idx]]
                    end
    compactor(idx)
    growth_check
  end

  def reassign(key, val, old_bucket)
    old_bucket.each do |arr|
      reassign(key, val, old_bucket) if arr.is_a?(Array)

      old_bucket.replace([key, val]) if old_bucket.first == key
    end
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
    bucket = @buckets[hash(key)]
    return nil unless bucket.is_a?(Array)

    clean_array = exterminate(key, bucket)
    @buckets[hash(key)] = bucket.empty? ? nil : bucket
    clean_array
  end

  def exterminate(key, bucket, removed_items = nil)
    bucket.each { |item| removed_items = exterminate(key, item, removed_items) if item.is_a?(Array) }
    bucket.reject!(&:empty?)
    return removed_items unless bucket.first == key

    removed_items = bucket.reject { |item| item.is_a?(Array) }
    bucket.select! { |item| item.is_a?(Array) }
    bucket.flatten!(1)
    removed_items
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
    keychain.push(arr.first) unless arr.first.nil? || arr.first.is_a?(Array)
    arr.each do |bucket|
      keys(bucket, keychain) if bucket.is_a?(Array)
    end
    keychain
  end

  def values(arr = @buckets, lockbox = [])
    lockbox.push(arr[1]) unless arr.first.nil? || arr.first.is_a?(Array)
    arr.each do |bucket|
      values(bucket, lockbox) if bucket.is_a?(Array)
    end
    lockbox
  end

  def entries(arr = @buckets, log = [])
    log.push([arr.first, arr[1]]) unless arr.first.nil? || arr.first.is_a?(Array)
    arr.each do |bucket|
      entries(bucket, log) if bucket.is_a?(Array)
    end
    log
  end
end

hmp = HashMap.new
loop do
  p 'Method name or EXIT'
  com = gets.chomp!
  break if com == 'EXIT'
  next unless hmp.respond_to?(com)

  p 'Applicable arguments'
  args = []
  p 'Argument 1'
  args.push(gets.chomp!)
  p 'Argument 2'
  args.push(gets.chomp!)
  args.delete_if(&:empty?)
  print "#{hmp.__send__(com, *args)}\n"
end
