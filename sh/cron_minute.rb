#!/usr/bin/env ruby
require 'config/environment'
puts Time.current.to_s(:db)
if Settings['run_cron']
  #RunEveryValidation.check_all!
end