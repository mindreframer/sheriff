#!/usr/bin/env ruby
require 'config/environment'
puts Time.current.to_s(:db)
RunEveryValidation.check_all!