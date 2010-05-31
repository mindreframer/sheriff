class RunEveryValidation < ActiveRecord::Base
  belongs_to :report

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

  def check!
    alert_options = {:severity => severity, :validation => self, :report => report}
    interval_as_text = "#{(Time.current - interval).to_s(:db)}..#{Time.current.to_s(:db)}"

    if (report.reported_at + buffer) < interval.seconds.ago
      Alert.create(alert_options.merge(
        :message => "Did not run in expected interval: #{report.reported_at.to_s(:db)} <-> #{interval_as_text}"
      ))
    elsif historic = report.historic_values.first
      if (historic.reported_at - buffer) >= interval.seconds.ago
        Alert.create(alert_options.merge(
          :message => "Reported more than once in interval: #{report.reported_at.to_s(:db)} + #{historic.reported_at.to_s(:db)} <-> #{interval_as_text}"
        ))
      end
    end
  end

  # 1 minutes ... 5% of interval ... 30.minutes
  def buffer
    [[1.minute, interval/20].max, 30.minutes].min
  end
end