class Alert < ActiveRecord::Base
  belongs_to :validation, :polymorphic => true
  belongs_to :report
  after_create :send_notification
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
end
