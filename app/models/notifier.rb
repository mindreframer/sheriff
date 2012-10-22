class Notifier < ActionMailer::Base
  default :from => "sheriff@dawanda.com"
  default :to   => CFG[:email_recipients].split(',')

  def self.test
    alert_data = OpenStruct.new({
      :report => OpenStruct.new({:full_name => 'Test'}),
      :message => 'This is just a test!',
      :report_id => 'none'
    })

    alert(alert_data).deliver
  end

  def alert(alert)
    mail :subject => "Sheriff Error -- #{alert.report.full_name}",
         :body    => "#{alert.message}\n#{Time.current.to_s(:db)} UTC\n#{CFG[:domain]}/reports/#{alert.report_id}"
  end

  def report_mail(alerts, timeframe)
    @alerts    = alerts
    @timeframe = timeframe
    mail :subject => "#{@alerts.size} errors happened in #{@timeframe / 60.0} minutes"
  end
end
