#!/usr/bin/env ruby
require 'config/environment'
puts Time.current.to_s(:db)
if Settings['run_cron'].to_bool
  #RunEveryValidation.check_all!
  Alert.generate_alert_report(2.minutes)
end