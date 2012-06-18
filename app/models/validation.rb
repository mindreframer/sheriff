class Validation < ActiveRecord::Base
  include ErrorLevelPropagation
  ERROR_LEVELS = {0 => 'Ignore', 1 => 'Log', 2 => 'Email', 3 => 'Sms'}
  before_update :adjust_current_error_level

  validates_format_of :ignore_start, :ignore_end, :with => /^\d\d:\d\d$/, :allow_blank => true
  validates_presence_of :ignore_end, :if => :ignore_start?
  validates_presence_of :ignore_start, :if => :ignore_end?

  def ignored?
    in_ignore_interval? or report.deputy.disabled?
  end

  def in_ignore_interval?
    return false if not ignore_end? or not ignore_start?

    now = Time.current
    now = "#{now.to_date} #{now.strftime("%H:%M:%S")}".to_time
    start_time = "#{now.to_date} #{ignore_start}:00".to_time
    end_time = "#{now.to_date} #{ignore_end}:00".to_time

    # adjust for day changes ?
    if start_time > end_time
      end_time += 1.day
      now += 1.day if now < start_time
    end

    now.between?(start_time, end_time)
  end

  def human_error_level
    ERROR_LEVELS[error_level]
  end

  protected

  def validation_failed!(message)
    return if ignored?
    if error_level != 0
      update_attributes!(:current_error_level => error_level)
      Alert.create(:message => message, :error_level => error_level, :validation => self, :report => report)
    else
      validation_passed!
    end
  end

  def validation_passed!
    update_attributes!(:current_error_level => 0) unless current_error_level == 0
  end

  def adjust_current_error_level
    self.current_error_level = error_level if error_level_changed? and current_error_level != 0
  end

end
