require "./1brc/output"
require "./1brc/stat"

module OneBRCSerial1
  include OneBRC
  extend self

  # Fixed point type used for temperature values
  # Using an alias since it helps test with different Int types
  alias FixPointInt = Int16

  # Each temperature metric
  alias Metric = Stat(FixPointInt, Int64)

  # Gather up metrics in a collector
  alias Collector = Hash(String, Metric)

  if ARGV.empty?
    puts "Requires file to load."
  end

  # Open input file
  file = File.new(ARGV.first, "r")
  file_size = file.size

  aggr = Collector.new
  file.each_line do |line|
    name, value = line.split(';')
    numval = FixPointInt.new(value.to_f * 10)

    case (rec = aggr[name]?)
    when nil
      aggr[name] = Metric.new(numval)
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
