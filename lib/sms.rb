require 'config/environment' unless defined?(Rails)
require 'open-uri'
require 'cgi'
require 'openssl'

class Sms
  def self.send(message, recipients)
    user = CFG[:sms_user]
    password = CFG[:sms_password]
    if ['development', 'staging'].include?(Rails.env)
      message = "#{Rails.env}: #{message}"
    end
    message = CGI.escape(message)

    recipients.each do |recipient|
      data = "id=#{user}&pw=#{password}&msgtype=t&receiver=#{recipient}&msg=#{message}&sender=Sheriff"
      url = "https://gate1.goyyamobile.com/sms/sendsms.asp?#{data}"
      without_ssl_verification do
        open(url).read if CFG[:send_sms]
      end
    end
  rescue Exception => e
    puts "SMS ERROR #{e.inspect}"
  end

  private

  def self.without_ssl_verification
    silence_warnings do
      begin
        old = OpenSSL::SSL::VERIFY_PEER
        OpenSSL::SSL.const_set(:VERIFY_PEER, OpenSSL::SSL::VERIFY_NONE)
        yield
      ensure
        OpenSSL::SSL.const_set(:VERIFY_PEER, old)
      end
    end
  end
end

# whe executed directly
if __FILE__ == $0
  Sms.send(ARGV[0]||raise('needs message!'), (ARGV[1]||CFG[:sms_recipients]).split(','))
end
