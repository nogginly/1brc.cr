module OneBRC
  # Weather station stat class, without name
  class Stat(VT, ST)
    property min : VT
    property max : VT
    property count : UInt32
    property sum : ST

    def initialize(value : VT)
      @min = @max = value
      @sum = ST.new(value)
      @count = 1_u32
    end

    @[AlwaysInline]
    def add(value : VT)
      @sum &+= value
      @count &+= 1
      @min = value if value < @min
      @max = value if value > @max
    end

    @[AlwaysInline]
    def add(rec : Stat)
      @sum &+= rec.sum
      @count &+= rec.count
      @min = rec.min if rec.min < @min
      @max = rec.max if rec.max > @max
    end
  end

  # Weather station stat, with name
  class NamedStat(VT, ST) < Stat(VT, ST)
    property name : Bytes

    def initialize(@name : Bytes, value : VT)
      super(value)
    end
  end
end
