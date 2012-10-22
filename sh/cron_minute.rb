#!/usr/bin/env ruby
### set the right rails env by default
env = if File.exist?('env')
  File.read('env').strip
else
  'development'
end
ENV['RAILS_ENV'] = env unless ENV['RAILS_ENV']


require 'config/environment'
puts Time.current.to_s(:db)
if Settings['run_cron'].to_bool
  #RunEveryValidation.check_all!
  Alert.generate_alert_report(2.minutes)
end