# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Dir["#{Gem.searcher.find('resque').full_gem_path}/tasks/*.rake"].each { |ext| load ext }

Rails::Application.load_tasks
