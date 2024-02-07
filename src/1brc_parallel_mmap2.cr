require "./1brc/output"
require "./1brc/macros"
require "./1brc/stat"
require "./1brc/mmap" # for posterity

module OneBRCParallelMmap
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
  BUF_DIV  = (ENV["BUF_DIV_DENOM"]? || 8).to_i
  PART_MAX = Int32::MAX // BUF_DIV

  # We allocate a few extra bytes per chunk to deal with the unpredictability
  # of where lines end and where we cut off a chunk; see further below for
  # details
  PART_XTRA = 32

  # We use this to convert ascii numerals to 0..9
  ZERO_ORD = UInt8.new('0'.ord)

  # Open input file
  file = File.new(ARGV.first, "r")
  file_size = file.size

  # Memory map the entire file
  file_void_ptr = LibC.mmap(nil, file_size, LibC::PROT_READ, LibC::MAP_PRIVATE, file.fd, 0)
  if file_void_ptr == LibC::MAP_FAILED
    raise RuntimeError.new("mmap failed: errno #{Errno.value}")
  end
  file_ptr = Pointer(UInt8).new(file_void_ptr.address)

  # Use page size to align part sizes
  page_size = LibC.sysconf(LibC::SC_PAGESIZE)

  # ensure part size is page aligned
  part_size = PART_MAX
  unless (rem = part_size % page_size).zero?
    part_size += page_size - rem
  end

  # divide up the work
  file_parts = if file_size > part_size
                 (file_size // part_size) + (file_size % part_size).clamp(0, 1)
               else
                 1
               end

  # Setup channels
  spawn_chan = Channel(Bool).new
  coll_chan = Channel(Collector).new

  # Launch up to PARALLEL_MAX fibers to do work
  PARALLEL_MAX.to_i64.times do |p_ix|
    spawn do
      aggr = Collector.new

      # Starting at p_ix process every Nth chunk where N = max threads
      p_ix.step to: file_parts, by: PARALLEL_MAX, exclusive: true do |ix|
        # Offset always based on part_size, which leaves the last
        # part to be smaller remainder
        ofs = (ix * part_size)
        size = if ofs + part_size < file_size
                 part_size
               else
                 file_size - ofs # remainder for last part
               end

        # Locate start point
        ptr = file_ptr + ofs

        begin
          # Use buffer with a little extra space unless we're
          # handling the last part of the file
          buf_size = if size < part_size
                       size # last part, use its actual size
                     else
                       size + PART_XTRA # not last part, grab some extra data
                     end
          # We use the extra bytes to deal with fact that we don't
          # know if a part will start and end at line start and end respectively
          read_pos = 0
          buf = Bytes.new(ptr, buf_size, read_only: true)

          # If not first part then move read position until we find start
          # of a line, since we can't assume part buffer starts at line
          if ofs > 0
            until ptr[read_pos].ascii_newline?
              read_pos &+= 1
            end
            read_pos &+= 1 # skip \n
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
            while ptr[read_pos] != ';'.ord
              read_pos &+= 1
            end
            name = buf[start, read_pos - start]
            read_pos &+= 1 # skip ';'

            # Next is either a digit or minus sign
            numval = if ptr[read_pos] == '-'.ord
                       read_pos &+= 1 # skip '-'
                       FixPointInt.new(-1)
                     else
                       FixPointInt.new(1)
                     end

            # read first digit of N.N or NN.N
            # this is ugly to avoid a loop by assuming the format
            d1 = ptr[read_pos] - ZERO_ORD
            __expect_digit(ptr[read_pos])
            numval *= if (d2 = ptr[read_pos &+ 1]) == '.'.ord
                        # parse N.N
                        read_pos &+= 2 # skip N.
                        d2 = ptr[read_pos] &- ZERO_ORD
                        __expect_digit(ptr[read_pos])
                        # return
                        TEMP10 &* d1 &+ d2
                      else
                        __expect_digit(ptr[read_pos + 1])
                        # parse NN.N
                        d2 &-= ZERO_ORD
                        read_pos &+= 3 # skip NN.
                        d3 = ptr[read_pos] &- ZERO_ORD
                        __expect_digit(ptr[read_pos])
                        # return
                        TEMP100 &* d1 &+ TEMP10 &* d2 &+ d3
                      end

            # skip last digit and expected newline
            read_pos &+= 2
            __expect_newline(ptr[read_pos - 1])

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
        end
      end
      # report completing this part's aggregation
      coll_chan.send aggr
    end
  end

  # Wait for an aggregation from each fiber and
  # merge into a single primary one
  aggr = Collector.new
  PARALLEL_MAX.times do |i|
    next_aggr = coll_chan.receive
    next_aggr.each do |name, in_rec|
      if (rec = aggr[name]?)
        rec.add(in_rec) # merge
      else
        aggr[name] = in_rec
      end
    end
  end

  # Release the mmap
  LibC.munmap(file_void_ptr, file_size)

  # Setup output
  output = if (outname = ARGV[1]?)
             File.new(outname, "w")
           else
             STDOUT
           end
  write_output(output, aggr)
  output.close unless output == STDOUT
end
