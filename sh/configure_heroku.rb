#! /usr/bin/env ruby
require 'rubygems'
require 'rake'
require 'base64'

config = Base64.encode64(File.read('config/config.heroku.yml')).gsub("\n","")
sh "heroku config:add CONFIG.YML=#{config}"
