require 'resque/server'

Resque::Server.use Rack::Auth::Basic do |username, password|
  username == 'yourname'
  password == 'yourpass'
end
