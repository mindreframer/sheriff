# https://gist.github.com/324196
require 'sinatra/base'

class ResqueWeb < Sinatra::Base
  require 'resque/server'
  use Rack::ShowExceptions

  if CFG[:user].present? and CFG[:password].present?
    Resque::Server.use Rack::Auth::Basic do |user, password|
      user == CFG[:user] && password == CFG[:password]
    end
  end

  def call(env)
    if env["PATH_INFO"] =~ /^\/resque/
      env["PATH_INFO"].sub!(/^\/resque/, '')
      env['SCRIPT_NAME'] = '/resque'

      @server ||= Resque::Server.new
      status, headers, body = @server.call(env)

      # in production with nginx, assets always hang endless <-> this fixes it
      if body.is_a? Sinatra::Helpers::StaticFile
        buffer = []
        body.each{|x| buffer << x }
        body = buffer
      end

      [status, headers, body]
    else
      super
    end
  end
end
