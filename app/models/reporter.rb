class Reporter
  def self.single_notification(alert)
    case alert.error_level
    when 2 then
      Reporter.send_mail(alert)
    when 3 then
      Reporter.send_mail(alert)
      Reporter.send_sms(alert)
    end
  end

  def self.multi_notification(alerts, timeframe)
    if alerts.size > 0
      SheriffMailer.report_mail(alerts, timeframe).deliver
    else
      puts "no errors happened in #{timeframe/60} minutes"
    end
  end

  def self.send_mail(alert)
    SheriffMailer.alert(alert).deliver
  end

  def self.send_sms(alert)
    Sms.send "#{alert.report.full_name} - #{alert.message}", CFG[:sms_recipients].to_s.split(',')
  end
end