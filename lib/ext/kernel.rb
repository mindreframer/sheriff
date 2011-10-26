module Kernel
  def Boolean(string)
    return true if string== true || string =~ (/(true|t|yes|y|1)$/i)
    return false if string== false || string.nil? || string =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{string}\"")
  end
end