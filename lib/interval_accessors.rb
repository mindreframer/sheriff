module IntervalAccessors
  UNITS = [[1.day.to_i, 'Days'], [1.hour.to_i, 'Hours'], [1.minute.to_i, 'Minutes'], [1.second.to_i, 'Seconds']].to_ordered_hash

  def interval_value
    interval.to_i / interval_unit
  end

  def interval_unit
    return 1.day if interval.to_i == 0
    [1.day, 1.hour, 1.minute, 1.second].detect{|unit| interval.to_f % unit == 0 }
  end

  def interval_unit_as_text
    UNITS[interval_unit]
  end

  def humanized_interval
    "#{interval_value} #{interval_unit_as_text}"
  end
end