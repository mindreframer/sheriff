source 'http://rubygems.org'

gem 'rails', '3.2.1'
gem 'mysql2', '>=0.3'
gem 'json'

gem 'active_record_inline_schema'
gem 'inherited_resources'
gem 'key_value', :require => false

# if you want to profile/check errors
gem 'hoptoad_notifier', :require => false
gem 'newrelic_rpm', '>=3', :require => false


# view stuff
gem 'dynamic_form'
gem 'kaminari'
gem 'jquery-rails'
gem 'sass-rails', "~> 3.2.1", :require => false
gem 'uglifier', :require => false
gem 'coffee-script', '2.2.0', :require => false
gem 'ace-rails-ap'
gem "twitter-bootstrap-rails", :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git', :ref => 'c248bbd4c19936a9624f19fa6fa91ca5c9617315'


# queue
gem 'resque', :require => false
gem 'resque-multi-job-forks', :git => "git://github.com/stulentsev/resque-multi-job-forks.git"


group :development do
  gem 'capistrano', '2.12.0', :require => false
  gem 'capistrano-ext', :require => false
  gem 'shotgun', :require => false
  gem 'thin'
end

group :test do
  gem 'factory_girl', :git => 'git://github.com/thoughtbot/factory_girl.git', :ref => '09e1cead5fc5239060d0a93ec045bbcc6fd99953'
  gem 'rspec-rails', '>=2'
  gem 'sqlite3'
end
