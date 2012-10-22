class Alert < ActiveRecord::Base
  belongs_to :validation, :polymorphic => true
  belongs_to :report
  # after_create :send_notification
  # after_create :report_to_fyrehose
  before_create :adjust_validation_type

  protected

  def adjust_validation_type
    self.validation_type = validation.class.to_s
  end

  def send_notification
    case error_level
    when 2 then
      send_mail
    when 3 then
      send_mail
      Sms.send "#{report.full_name} - #{message}", CFG[:sms_recipients].to_s.split(',')
    end
  end

  def send_mail
    SheriffMailer.alert(self).deliver
  end

  def report_to_fyrehose
    return if error_level < 1
    prio = if error_level == 2
      "[CRITICAL] "
    elsif error_level == 3
      "[DOOM] "
    else
      ""
    end

    ReporterFyrehose.report(
      :token => "sherrif.#{report.group.full_name}",
      :msg   => "#{prio}#{report.full_name} - #{message}"
    )
  end

  def self.generate_alert_report(timeframe=nil)
    timeframe ||= 30.minutes
    alerts = Alert.find(:all, :conditions => ["created_at >= ?", Time.now.utc - timeframe ])
    if alerts.size > 0
      SheriffMailer.report_mail(alerts, timeframe).deliver
    else
      puts "no errors happened in #{timeframe/60} minutes"
    end
  end
end