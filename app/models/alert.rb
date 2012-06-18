class Alert < ActiveRecord::Base
  belongs_to :validation, :polymorphic => true
  belongs_to :report
  after_create :send_notification
  after_create :report_to_fyrehose
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
    Notifier.alert(self).deliver
  end

  def report_to_fyrehose
    return true unless CFG[:report_to_fyrehose]
    return if error_level < 1

    msg = "#{report.full_name} - #{message}"

    prio = if error_level == 1
      "low"
    elsif error_level == 2
      "high"
    elsif error_level == 3
      "doom"
    end

    pub = {
      :token => "sherrif.#{self.report.group.full_name}",
      :channel => CFG[:report_to_fyrehose_channel],
      :type => "issue",
      :message => msg,
      :priority => prio
    }

    sock = UDPSocket.new
    sock.connect(*CFG[:report_to_fyrehose].split(":"))
    sock.write(pub.to_json + "\n")
    sock.close
  rescue Exception => e
    puts "cant report to fyrehose: #{e.to_s}"
  end

end
