# http://github.com/mynyml/unindent/blob/master/lib/unindent.rb
class String
  def unindent
    indent = self.split("\n").select {|line| !line.strip.empty? }.map {|line| line.index(/[^\s]/) }.compact.min
    self.gsub(/^[[:blank:]]{#{indent}}/, '')
  end
  def unindent!
    self.replace(self.unindent)
  end

  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end