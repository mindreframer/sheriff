class RunBetweenValidation < Validation
  belongs_to :report

  def start_hms
    start_seconds.try(:to_hms)
  end

  def start_hms=(x)
    self.start_seconds = Time.parse(x).seconds_after_midnight
  end

  def end_hms
    end_seconds.try(:to_hms)
  end

  def end_hms=(x)
    self.end_seconds = Time.parse(x).seconds_after_midnight
  end

  def human_display
    "runs between #{start_hms} and #{end_hms} (#{human_error_level})"
  end

  def check!
    if report.reported_at.seconds_after_midnight.between?(start_seconds, end_seconds)
      validation_passed!
    else
      validation_failed! "Did not run in expected interval #{Time.seconds_after_midnight.to_hms} <-> #{start_hms}..#{end_hms}"
    end
  end
end
