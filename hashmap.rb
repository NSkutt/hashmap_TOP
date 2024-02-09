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
    @buckets[idx] = [key, val, @buckets[idx]]
    compactor(idx)
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
    bucket = @buckets[hash(key)]
    return nil unless bucket.is_a?(Array)

    holding_array = Marshal.load(Marshal.dump(bucket))
    clean_array = exterminate(key, bucket)
    subtracted_items = holding_array - clean_array
    subtracted_items.flatten!(1) if subtracted_items.first.is_a?(Array)
    subtracted_items.reject { |item| item.is_a?(Array) }
  end

  def exterminate(key, bucket)
    bucket.each { |item| exterminate(key, item) if item.is_a?(Array) }
    bucket.reject!(&:empty?)
    return bucket unless bucket.first == key

    bucket.select! { |item| item.is_a?(Array) }
    bucket.flatten!(1)
    bucket
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
