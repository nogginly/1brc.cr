#
# Simple hash table using the FxHash hashing funtion used by the Rust compiler.
# As implemented, it is not ideal for general use. However it is faster than `Hash` when
# looking up entries and as a result improved performance by ~20-30%.
class FxHashMap(V)
  # Maximum capacity of the hash map; no of entries cannot exceed this
  CAPACITY    = 1 << 12
  BUCKET_MASK = CAPACITY - 1

  # Convenience
  alias Key = Bytes

  # Each entry
  private class Entry(V)
    property key : Key
    property value : V

    def initialize(@key, @value); end
  end

  # Fixed size array of entries
  @entries : Array(Entry(V)?)

  # Track size for faster retrieval
  getter size : Int32 = 0

  # Create an empty `FxHashMap` instance
  def initialize
    # This initialization is slow; luckily doesn't impact the use in 1brc
    # because the use dominates.
    @entries = Array(Entry(V)?).new(CAPACITY, nil)
  end

  # This yields 6 collision for 1 << 12
  HASH_SEED = 0x71b1e4d7.to_u32
  HASH_ROT  = 5

  @[AlwaysInline]
  private def fxhash(x : UInt32, y : UInt32)
    # https://github.com/gunnarmorling/1brc/blob/main/src/main/java/dev/morling/onebrc/CalculateAverage_merykitty.java
    # based on FxHash from Rust
    ((x &* HASH_SEED).rotate_left(HASH_ROT) ^ y) &* HASH_SEED
  end

  # Returns the hash for the key using `fxhash` on the key
  private def hash(key : Key)
    ks = key.size # in bytes
    kp = key.to_unsafe.address
    # Depending on key size do the hashing on the biggest integers possible
    if ks >= sizeof(UInt32)
      fxhash(
        Pointer(UInt32).new(kp).value,
        Pointer(UInt32).new(kp &+ ks &- sizeof(UInt32)).value)
    elsif ks >= sizeof(UInt16)
      fxhash(
        Pointer(UInt16).new(kp).value,
        Pointer(UInt16).new(kp &+ ks &- sizeof(UInt16)).value)
    else
      fxhash(key[0], key[0])
    end
  end

  # Find entry, or `nil` if none with that key.
  def []?(key : Key) : V?
    ix = hash(key) & BUCKET_MASK

    while (ent = @entries.unsafe_fetch(ix))
      return ent.value if ent.key == key
      ix = (ix &+ 1) & BUCKET_MASK
    end
    nil
  end

  # Find entry by key, raising `KeyError` if not found
  def [](key : Key) : V
    self[key]? || raise KeyError.new
  end

  # Set value by key, replacing value if already exists
  def []=(key : Key, value : V) : V?
    ix = hash(key) & BUCKET_MASK

    until (ent = @entries.unsafe_fetch(ix)).nil?
      if ent.key == key
        oldval = ent.value
        ent.value = value
        return oldval
      end
      ix = (ix &+ 1) & BUCKET_MASK
    end
    @entries.unsafe_put(ix, Entry.new(key, value))
    @size += 1
    nil # means new value
  end

  # Itetate over each key and value pair
  def each
    @entries.each do |spot|
      if (ent = spot)
        yield ent.key, ent.value
      end
    end
  end

  # Itetate over each key
  def each_key
    @entries.each do |spot|
      if (ent = spot)
        yield ent.key
      end
    end
  end

  # Return an array of keys in the table
  def keys
    keys_ar = [] of Key
    self.each_key do |k|
      keys_ar << k
    end
    keys_ar
  end
end
