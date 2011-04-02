# https://gist.github.com/324196
require 'sinatra/base'

class ResqueWeb < Sinatra::Base
  require 'resque/server'
  use Rack::ShowExceptions

  Resque::Server.use Rack::Auth::Basic do |user, password|
    user == CFG[:user] && password == CFG[:password]
  end

  def call(env)
    if env["PATH_INFO"] =~ /^\/resque/
      env["PATH_INFO"].sub!(/^\/resque/, '')
      env['SCRIPT_NAME'] = '/resque'
      app = Resque::Server.new
      app.call(env)
    else
      super
    end
  end
end
