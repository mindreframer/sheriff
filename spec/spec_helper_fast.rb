require 'bundler'
Bundler.setup
require 'rspec'
require 'ostruct'
require 'active_support/all'

ENV["RAILS_ENV"] ||= 'test'
### see: http://www.scottw.com/ruby-1-9-2-load
$LOAD_PATH << '.'



RSpec.configure do |config|
  config.mock_with :rspec
end


module TestHelper
  def self.require_models
    require 'active_record_inline_schema'
    TestHelper.require_ext
    ActiveRecord::Base.establish_connection :adapter =>  "sqlite3", :database => ":memory:"

    require 'app/models/settings.rb'
    require 'key_value'

    models = ::ObjectSpace.each_object(::Class).select do |c|
      c.ancestors.include?(ActiveRecord::Base)
    end
    # models.each do |m|
    #   m.auto_upgrade!
    # end
  end


  def self.require_ext
    Dir["./lib/ext/**/*.rb"].each do |file|
      require "./" + file.sub('.rb','')
    end
  end
end