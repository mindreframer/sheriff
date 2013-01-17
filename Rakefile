# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rdoc/task'

task :default do
  sh "bundle exec sh/test_fast"
end

desc "run slow controller tests"
task :test_slow do
  sh "bundle exec sh/test_slow"
end

Sheriff::Application.load_tasks
