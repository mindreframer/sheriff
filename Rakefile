# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

if CFG[:resque]
  require 'resque/tasks.rb'

  namespace :resque do
    task :setup => :environment do
      require 'resque-multi-job-forks'
    end
  end
else
  namespace :resque do
    task :workers do
      puts "Resque is deactivated, have a nice day :>"
    end
  end
end

Rails::Application.load_tasks
