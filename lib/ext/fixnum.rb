class Fixnum
  def to_hms
    Time.at(self).utc.strftime("%H:%M:%S")
  end
end