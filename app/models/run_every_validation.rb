class RunEveryValidation < Validation
  include IntervalAccessors
  belongs_to :report

  def check!
    alert_options = {:error_level => error_level, :validation => self, :report => report}
    interval_as_text = "#{(Time.current - interval).to_s(:db)}..#{Time.current.to_s(:db)}"

    if (report.reported_at + buffer) < interval.seconds.ago
      Alert.create(alert_options.merge(
        :message => "Did not run in expected interval: #{report.reported_at.to_s(:db)} <-> #{interval_as_text}"
      ))
    elsif only_run_once? and historic = report.historic_values.first
      if (historic.reported_at - buffer) >= interval.seconds.ago
        Alert.create(alert_options.merge(
          :message => "Reported more than once in interval: #{report.reported_at.to_s(:db)} + #{historic.reported_at.to_s(:db)} <-> #{interval_as_text}"
        ))
      end
    end
  end

  def self.check_all!
    all.each(&:check!)
  end

  # 1 minutes ... 5% of interval ... 30.minutes
  def buffer
    [[1.minute, interval/20].max, 30.minutes].min
  end
end