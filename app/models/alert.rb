class Alert < ActiveRecord::Base
  belongs_to :validation, :polymorphic => true
  belongs_to :report
  after_create :send_notification

  protected

  def send_notification
    case error_level
    when 2 then Notifier.alert(self).deliver
    when 3 then Sms.send "#{report.full_name} - #{message}", CFG[:sms_recipients].split(',')
    end
  end
end