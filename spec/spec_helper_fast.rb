require 'bundler'
Bundler.setup
require 'rspec'
require 'ostruct'
require 'active_support/all'

ENV["RAILS_ENV"] ||= 'test'
### see: http://www.scottw.com/ruby-1-9-2-load
$: << '.'



RSpec.configure do |config|
  config.mock_with :rspec
end
