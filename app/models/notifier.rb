class Notifier < ActionMailer::Base
  default :from => "sheriff@dawanda.com"
  default :to => CFG[:email_recipients].split(',')

  def alert(alert)
    mail :subject => "Sheriff Error -- #{alert.report.full_name}"
  end
end