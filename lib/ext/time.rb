Time::DATE_FORMATS[:hms] = "%H:%M:%S"

class Time
  def self.seconds_after_midnight
    Time.now.seconds_after_midnight
  end

  def seconds_after_midnight
    (self - at_beginning_of_day).to_i
  end
end