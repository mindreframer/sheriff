class Notifier < ActionMailer::Base
  default :from => "sheriff@dawanda.com"
  default :to   => CFG[:email_recipients].split(',')

  def self.test
    mail(:subject => "Sheriff Test -- Hello world", :body => 'Just a test.').deliver
  end

  def alert(alert)
    mail :subject => "Sheriff Error -- #{alert.report.full_name}",
         :body    => "#{alert.message}\n#{Time.current.to_s(:db)} UTC\n#{CFG[:domain]}/reports/#{alert.report_id}"
  end
end
