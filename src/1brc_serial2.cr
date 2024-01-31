require "./1brc/output"
require "./1brc/stat"

module OneBRCSerial2
  include OneBRC
  extend self

  # Fixed point type used for temperature values
  # Using an alias since it helps test with different Int types
  alias FixPointInt = Int16

  # Temperature constants in the target type
  TEMP10 = FixPointInt.new(10)

  # We use this to convert ascii numerals to 0..9
  ZERO_ORD = UInt8.new('0'.ord)

  # Each temperature metric
  alias Metric = Stat(FixPointInt, Int64)

  # Gather up metrics in a collector
  alias Collector = Hash(Bytes, Metric)

  if ARGV.empty?
    puts "Requires file to load."
  end

  # Open input file
  file = File.new(ARGV.first, "r")
  # Note. Increasing the file.buffer_size made performance worse!

  aggr = Collector.new
  buf = Bytes.new(128) # Longest line is shorter than this

  #
  # Use wrapping (i.e. non-overflow checking) maths ops
  # inside the loop
  #
  done = false
  while !done
    # Read line of bytes upto EOL or EOF
    len = 0
    until (done = (b = file.read_byte).nil?)
      break if b.ascii_newline?
      buf[len] = b
      len += 1
    end

    read_pos = 0

    # read name until semicolon
    while (b = buf[read_pos]) != ';'.ord
      read_pos &+= 1
    end
    name = buf[0, read_pos]
    read_pos &+= 1

    # Next is either a digit or minus sign
    sign = if buf[read_pos] == '-'.ord
             read_pos &+= 1
             FixPointInt.new(-1)
           else
             FixPointInt.new(1)
           end

    # read number
    numval = FixPointInt.new(0)
    while (b = buf[read_pos]) != '.'.ord
      numval = (numval &* TEMP10) &+ (b &- ZERO_ORD)
      read_pos &+= 1
    end
    numval = sign &* ((numval &* TEMP10) &+ (buf[read_pos &+ 1] &- ZERO_ORD))

    # process the record
    case (rec = aggr[name]?)
    when nil
      aggr[name.dup] = Metric.new(numval)
    else
      rec.add(numval)
    end
  end

  # Setup output
  output = if (outname = ARGV[1]?)
             File.new(outname, "w")
           else
             STDOUT
           end
  write_output(output, aggr)
  output.close unless output == STDOUT
end
