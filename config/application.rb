require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'open-uri'

Bundler.require(:default, Rails.env) if defined?(Bundler)

require 'newrelic_rpm' if File.exist?('config/newrelic.yml')

require File.expand_path('../../lib/cfg', __FILE__)

require 'resque' if CFG[:resque]



module Sheriff
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    config.middleware.use 'ResqueWeb' if CFG[:resque]

    config.autoload_paths << "lib"
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.consider_all_requests_local = true
    config.active_support.deprecation = :log

    config.assets.enabled = true
    config.assets.version = '1.0' # Version of your assets, change this if you want to expire all your assets
  end
end
