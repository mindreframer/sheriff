module Kernel
  def Boolean(string)
    return true if string== true || string =~ (/(true|t|yes|y|1)$/i)
    return false if string== false || string.nil? || string =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{string}\"")
  end

  if RUBY_VERSION < "1.9"
    def ruby_18
      yield
    end

    def ruby_19
      false
    end
  else
    def ruby_18
      false
    end

    def ruby_19
      yield
    end
  end
end

module Kernel
  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    return result
  end
end