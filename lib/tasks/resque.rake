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
