# https://gist.github.com/1214052
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
    @server ||= Resque::Server.new
    status, headers, body = @server.call(env)

    # in production/staging with nginx, assets always hang endless <-> this fixes it
    if body.is_a? Sinatra::Helpers::StaticFile
      buffer = []
      body.each{|x| buffer << x }
      body = buffer
    end

    [status, headers, body]
  end
end
