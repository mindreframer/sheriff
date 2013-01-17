class Alert < ActiveRecord::Base

  # inline schema
  col :error_level,     :type => :integer, :null => false
  col :message,         :type => :string,  :null => false
  col :validation_id,   :type => :integer, :null => false
  col :validation_type, :type => :string,  :null => false
  col :report_id,       :type => :integer, :null => false
  col :created_at,      :type => :datetime
  col :updated_at,      :type => :datetime


  belongs_to :validation, :polymorphic => true
  belongs_to :report
  # after_create :send_notification
  # after_create :report_to_fyrehose
  before_create :adjust_validation_type

  protected

  def adjust_validation_type
    self.validation_type = validation.class.to_s
  end

  def report_to_fyrehose
    ReporterFyrehose.send_alert(self)
  end

  def self.generate_alert_report(timeframe=nil)
    timeframe ||= 30.minutes
    alerts = Alert.find(:all,
        :conditions => ["created_at >= ? AND error_level > 1", Time.now.utc - timeframe ])
    Reporter.multi_notification(alerts, timeframe)
  end
end