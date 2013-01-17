require 'bundler'
Bundler.setup
require 'rspec'
require 'ostruct'
require 'active_support/all'

ENV["RAILS_ENV"] ||= 'test'
### see: http://www.scottw.com/ruby-1-9-2-load
$LOAD_PATH << '.'


require 'active_support'
require 'active_support/dependencies'
relative_load_paths = %w[app/models app/actions lib]
ActiveSupport::Dependencies.autoload_paths += relative_load_paths

require 'factory_girl'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end

module TestHelper
  def self.require_models
    return if @required
    require 'active_record_inline_schema'
    TestHelper.require_ext
    ActiveRecord::Base.establish_connection :adapter =>  "sqlite3", :database => ":memory:"

    models = %w[
      alert
      deputy
      deputy_plugin
      group
      historic_value
      plugin
      report
      settings
      validation
    ]
    models.each { |e| require "app/models/#{e}" }
    require 'key_value'

    (models = ::ObjectSpace.each_object(::Class).select do |c|
      c.ancestors.include?(ActiveRecord::Base)
    end - [ActiveRecord::Base])

    models.each do |m|
      m.auto_upgrade!
    end
    @required = true
  end

  def self.require_ext
    Dir["./lib/ext/**/*.rb"].each do |file|
      require "./" + file.sub('.rb','')
    end
  end
end
TestHelper.require_models