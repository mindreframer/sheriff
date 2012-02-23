class RunEveryValidation < Validation
  include IntervalAccessors
  include ActionView::Helpers::DateHelper
  belongs_to :report

  def check!
    interval_start = interval.seconds.ago
    interval_as_text = "#{interval_start.to_s(:db)}..#{Time.current.to_s(:db)}"

    if (report.reported_at + buffer) < interval_start
      validation_failed! "Did not run in expected interval: #{report.reported_at.to_s(:db)} <-> #{interval_as_text}"
    elsif only_run_once? and historic = report.historic_values.first
      if (historic.reported_at - buffer) >= interval.seconds.ago
        validation_failed! "Reported more than once in interval: #{report.reported_at.to_s(:db)} + #{historic.reported_at.to_s(:db)} <-> #{interval_as_text}"
      end
    else
      validation_passed!
    end
  end

  def human_display
    "runs every #{distance_of_time_in_words(interval)} (#{human_error_level})"
  end

  def self.check_all!
    all.each(&:check!)
  end

  # 1 minutes ... 5% of interval ... 30.minutes
  def buffer
    [[1.minute, interval/20].max, 30.minutes].min
  end
end
