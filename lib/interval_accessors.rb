module IntervalAccessors
  def interval_value
    interval.to_i / interval_unit
  end

  def interval_unit
    return 1.day if interval.to_i == 0
    [1.day, 1.hour, 1.minute, 1.second].detect{|unit| interval.to_f % unit == 0 }
  end

  def humanized_interval
    "#{interval_value} #{interval_unit}"
  end
end