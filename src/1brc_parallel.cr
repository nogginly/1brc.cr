require "./1brc/output"
require "./1brc/macros"
require "./1brc/stat"

module OneBRCParallel
  include OneBRC
  extend self

  # Fixed point type used for temperature values
  # Using an alias since it helps test with different Int types
  alias FixPointInt = Int16

  # Each temperature metric
  alias Metric = Stat(FixPointInt, Int64)

  # Each fibre gathers up its metrics in a collector
  alias Collector = Hash(Bytes, Metric)

  # Temperature constants in the target type
  TEMP10  = FixPointInt.new(10)
  TEMP100 = FixPointInt.new(100)

  # Maximum fibres to spawn
  PARALLEL_MAX = (ENV["CRYSTAL_WORKERS"]? || 4).to_i

  # Size of portion (part) of file to handler per fibre
  # Crystal array max size if limited to Int32::MAX so we
  # use that as the base to define the chunk size in bytes
  PART_MAX = Int32::MAX // (ENV["BUF_DIV_DENOM"]? || 8).to_i

  # We allocate a few extra bytes per chunk to deal with the unpredictability
  # of where lines end and where we cut off a chunk; see further below for
  # details
  PART_XTRA = 32

  # We use this to convert ascii numerals to 0..9
  ZERO_ORD = UInt8.new('0'.ord)

  # Open input file
  file = File.new(ARGV.first, "r")
  file_size = file.size

  # divide up the work
  file_parts = if file_size > PART_MAX
                 (file_size // PART_MAX) + (file_size % PART_MAX).clamp(0, 1)
               else
                 typeof(file_size).new(PARALLEL_MAX)
               end
  part_size = file_size // file_parts # Each part's size
  part_rem = file_size % file_parts   # Remainder

  # Setup channels
  spawn_chan = Channel(Bytes).new
  coll_chan = Channel(Collector).new

  # Launch a fiber per file part (which we calculate based on the chunk size)
  # but we only activate up to PARALLEL_MAX fibers to do work, the rest wait
  # for others to finish
  file_parts.times do |ix|
    spawn do
      aggr = Collector.new

      # The first part's size includes the remainder
      # All others are just the part size
      ofs, size = if ix.zero?
                    {0, part_size + part_rem}
                  else
                    {ix * part_size + part_rem, part_size}
                  end

      # Allocate a buffer for up to PARALLEL_MAX fibers
      # The rest wait to receive and re-use the buffer when the earlier fibers finish
      back_buf = if ix < PARALLEL_MAX
                   Bytes.new(part_size + part_rem + PART_XTRA)
                 else
                   spawn_chan.receive
                 end

      begin
        # Use buffer with a little extra space unless we're
        # handling the last part of the file
        buf_size = if ofs + size >= file_size
                     size
                   else
                     size + PART_XTRA
                   end
        # We use the extra bytes to deal with fact that we don't
        # know if a part will start and end at line start and end respectively
        buf = back_buf[0, buf_size]
        buf_read = file.read_at offset: ofs, bytesize: buf_size do |io|
          io.read_fully(buf)
        end
        read_pos = 0

        # If not first part then move read position until we find start
        # of a line, since we can't assume part buffer starts at line
        if ofs > 0
          until buf[read_pos].ascii_newline?
            read_pos += 1
          end
          read_pos += 1 # skip \n
        end

        #
        # Use wrapping (i.e. non-overflow checking) maths ops
        # inside the loop
        #
        while read_pos < size
          # Enter ths loop if read position is prior to end of expected buffer.  Inside the loop,
          # assume if we made it in, we can expect valid line of "aaaaaa;99.9\n" and
          # so allow read position to go past the expected end
          #
          # BECAUSE !!!
          # We read in extra bytes more than the appoprtioned size (unless last part)

          # read name until semicolon
          start = read_pos
          while buf[read_pos] != ';'.ord
            read_pos &+= 1
          end
          name = buf[start, read_pos - start]
          read_pos &+= 1 # skip ';'

          # Next is either a digit or minus sign
          numval = if buf[read_pos] == '-'.ord
                     read_pos &+= 1 # skip '-'
                     FixPointInt.new(-1)
                   else
                     FixPointInt.new(1)
                   end

          # read first digit of N.N or NN.N
          # this is ugly to avoid a loop by assuming the format
          d1 = buf[read_pos] - ZERO_ORD
          __expect_digit(buf[read_pos])
          numval *= if (d2 = buf[read_pos &+ 1]) == '.'.ord
                      # parse N.N
                      read_pos &+= 2 # skip N.
                      d2 = buf[read_pos] &- ZERO_ORD
                      __expect_digit(buf[read_pos])
                      # return
                      TEMP10 &* d1 &+ d2
                    else
                      __expect_digit(buf[read_pos + 1])
                      # parse NN.N
                      d2 &-= ZERO_ORD
                      read_pos &+= 3 # skip NN.
                      d3 = buf[read_pos] &- ZERO_ORD
                      __expect_digit(buf[read_pos])
                      # return
                      TEMP100 &* d1 &+ TEMP10 &* d2 &+ d3
                    end

          # skip last digit and expected newline
          read_pos &+= 2
          __expect_newline(buf[read_pos - 1])

          # process the record
          if (rec = aggr[name]?)
            rec.add(numval)
          else
            aggr[name.dup] = Metric.new(numval)
          end
        end
      rescue x
        STDERR << "!! #{ix} "
        x.inspect_with_backtrace STDERR
      ensure
        # report completing this part's aggregation
        coll_chan.send aggr
        # hand-off buffer to a waiting fiber
        spawn_chan.send back_buf
      end
    end
  end

  # Wait for an aggregation from each fiber and
  # merge into a single primary one
  aggr = Collector.new
  file_parts.times do |i|
    next_aggr = coll_chan.receive
    next_aggr.each do |name, in_rec|
      if (rec = aggr[name]?)
        rec.add(in_rec) # merge
      else
        aggr[name] = in_rec
      end
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
