require 'config/environment' unless defined?(Rails)
require 'open-uri'
require 'cgi'

class Sms
  def self.send(message, recipients)
    message = CGI.escape(message)
    user = CFG[:sms_user]
    password = CFG[:sms_password]

    if ['development', 'staging'].include?(Rails.env)
      message = "#{Rails.env}: #{message}"
    end

    recipients.each do |recipient|
      data = "id=#{user}&pw=#{password}&msgtype=t&receiver=#{recipient}&msg=#{message}&sender=Sheriff"
      url = "https://gate1.goyyamobile.com/sms/sendsms.asp?#{data}"
      open(url).read unless CFG[:send_sms]
    end
  rescue Exception => e
    puts "SMS ERROR #{e.inspect}"
  end
end

# whe executed directly
if __FILE__ == $0
  Sms.send(ARGV[0]||raise('needs message!'), (ARGV[1]||CFG[:sms_recipients]).split(','))
end
