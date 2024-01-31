# Extending integers with
#   - ASCII conveniences
#   - Rounding division
abstract struct Int
  # Integer division with rounding
  def div(d)
    (self + d // 2) // d
  end

  # Return true if value ASCII value
  def ascii?
    0 <= self <= 255
  end

  # Return true if value ASCII digit
  def ascii_number?
    '0'.ord <= self <= '9'.ord
  end

  # Return true if value ASCII whitespace
  def ascii_whitespace?
    self == ' '.ord || 9 <= self <= 13
  end

  # Return true if value ASCII newline
  def ascii_newline?
    self == '\n'.ord
  end
end
