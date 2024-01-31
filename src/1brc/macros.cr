module OneBRC
  #
  # These macros all assume they are running within the fibre
  # block with the following local variables in scope:
  #
  # - `buf`       - the bytes being processed
  # - `start`     - the current line's start offset
  # - `read_pos`  - the current byte offset in the buffer
  #

  # Includes *block* if the `xtra_debug` flag was set at build time
  macro __if_debug(&block)
    {% if flag?(:xtra_debug) %}
    {{ block.body }}
    {% end %}
  end

  macro __expect_digit(b)
    __if_debug do
      unless b.ascii_number?
        raise RuntimeError.new(
          "Unexpected #{b} '#{b.unsafe_chr}' not number: <#{String.new(buf[start, read_pos - start])}>")
      end
    end
  end

  macro __expect_newline(b)
    __if_debug do
      unless b.ascii_newline?
        raise RuntimeError.new(
          "Newline expected! <#{String.new(buf[start, read_pos - start])}>")
      end
    end
  end

  macro __expect_char(b, c)
    __if_debug do
      unless b == c
        raise RuntimeError.new(
          "Unexpected #{b} '#{b.unsafe_chr}' not #{c}: <#{String.new(buf[start, read_pos - start])}>")
      end
    end
  end
end
