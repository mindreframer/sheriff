require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'open-uri'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Sheriff
  class Application < Rails::Application
  
    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    config.middleware.use 'ResqueWeb'

    config.autoload_paths << "lib"
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.consider_all_requests_local = true
    config.active_support.deprecation = :log
  end
end
