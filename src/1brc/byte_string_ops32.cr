module ByteStrOps32
  macro __mask32(b)
    {% if b.is_a? CharLiteral %}
      {% b = b.ord %}
    {% end %}
    {% if (b & 0xff == b) %}
      {% m = 0xff_u32 & b %}
      {% m = m << 8 | m %}
      {% m = m << 16 | m %}
      {{ m }}
    {% else %}
      {% raise "8-bit unsigned value required. #{b} invalid." %}
    {% end %}
  end

  @[AlwaysInline]
  def self.find_byte_by4_with(mask : UInt32, p : Pointer(UInt8), n) : Int32
    # process in 32bit chunks
    n4 = n >> 2
    p4 = Pointer(UInt32).new(p.address)
    i = 0
    while i < n4
      x = (p4[i] ^ mask)
      s = (x &- __mask32(0x01)) & ((~x) & __mask32(0x80))
      unless s.zero?
        # we use trailing zero's because of the byte order representation
        # TODO: does this mean in big-endian system we need to count leading zeros?
        return (i << 2) &+ (s.trailing_zeros_count >> 3)
      end
      i &+= 1
    end
    # process remaining up to 3 bytes as bytes
    i = n4 << 2
    b = (mask & 0xff).to_u8
    while i < n
      return i if p[i] == b
      i &+= 1
    end

    raise RuntimeError.new("Unable to find: 0x#{b.to_s(16)}")
  end

  macro find_byte_by4(b, p, n)
    {% if b.is_a? CharLiteral %}
      {% b = b.ord %}
    {% end %}
    {% if b.is_a? NumberLiteral %}
      {% m = 0xff_u32 & b %}
      {% m = m << 8 | m %}
      {% m = m << 16 | m %}
      ByteStrOps32.find_byte_by4_with({{ m }} , {{p}}, {{n}})
    {% else %}
      # if b is not a literal, compute mask at runtime
      %mask = 0xff_u32 & {{ b }}
      %mask = %mask << 8 | %mask
      %mask = %mask << 16 | %mask
      ByteStrOps32.find_byte_by4_with(%mask , {{p}}, {{n}})
    {% end %}
  end
end
