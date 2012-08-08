ENV["RAILS_ENV"] ||= 'test'
### see: http://www.scottw.com/ruby-1-9-2-load
$: << '.'

require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails)
require 'rspec/rails'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end
