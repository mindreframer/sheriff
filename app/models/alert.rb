class Alert < ActiveRecord::Base
  belongs_to :validation, :polymorphic => true
  belongs_to :report
  after_create :send_notification

  protected

  def send_notification
    case error_level
    when 2 then send_mail
    when 3 then
      send_mail
      Sms.send "#{report.full_name} - #{message}", CFG[:sms_recipients].split(',')
    end
  end

  def send_mail
    Notifier.alert(self).deliver
  end
end