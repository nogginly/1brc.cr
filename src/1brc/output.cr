require "./int_plus"
require "./stat"

module OneBRC
  private def write_val(io, ival)
    if ival.negative?
      io << '-'
      ival = -ival
    end
    frac = ival % 10
    io << ival // 10
    io << '.' << frac # unless frac.zero?
  end

  private def write(io, min, mean, max, last = false)
    write_val io, min
    io << '/'
    write_val io, mean
    io << '/'
    write_val io, max
    io << ',' << ' ' unless last
  end

  def write_output(output, aggr)
    output.set_encoding("utf-8")
    output << '{'

    aggr_last_ix = aggr.size - 1

    # Sort and output each aggregated record
    aggr.keys.sort!.each_with_index do |name, i|
      rec = aggr[name]
      mean = rec.sum.div(rec.count)

      case name
      when Bytes then output.write_string(name)
      else
        output << name
      end

      output << '='
      write(output,
        min: rec.min,
        mean: rec.sum.div(rec.count),
        max: rec.max,
        last: i >= aggr_last_ix)
    end
    output.puts('}')
  end
end
