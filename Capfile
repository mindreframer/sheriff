# PUBLIC  REPO,  DO  NOT  ADD  PASSWORDS
# PUBLIC  REPO,  DO  NOT  ADD  PASSWORDS
# PUBLIC  REPO,  DO  NOT  ADD  PASSWORDS
# PUBLIC  REPO,  DO  NOT  ADD  PASSWORDS
# PUBLIC  REPO,  DO  NOT  ADD  PASSWORDS
load 'deploy'
require 'bundler/capistrano'

set :default_stage, "staging"
set :stages, %w(production staging)
require 'capistrano/ext/multistage'

set :application, "Sheriff"
set :scm, :git
set :repository, "git@github.com:dawanda/sheriff.git"

current_branch = ENV['BRANCH'] || `git branch | grep '*'`.split.last
set :branch, current_branch

set :deploy_to, '/srv/sheriff'
set :keep_releases, 3

set :user, "deploy"
set :use_sudo, false

namespace :deploy do
 task(:start){}
 task(:stop){}

  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt" unless ENV['NO_RESTART']
  end

  desc "Compile assets"
  task :assets do
    run "cd #{current_release} && RAILS_ENV=#{stage} bundle exec rake assets:precompile"
  end
  before "deploy:symlink", "deploy:assets"

  desc "Copy config files to config/"
  task :copy_config_files, :roles => [:app, :db] do
    run "cp -R #{deploy_to}/shared/config/* #{current_release}/config/"
  end
  after 'deploy:update_code', 'deploy:copy_config_files'

  desc "add a file that tells us which env we are on"
  task :add_env do
    run "echo #{stage} > #{current_release}/env"
  end
  after 'deploy:update_code', 'deploy:add_env'
end
after 'deploy', 'deploy:cleanup'

# If deactivated resque, this will run an empty rake task, no need to worry
namespace :resque do
  namespace :worker do
    desc "start"
    task :start, :roles => :resque_worker do
      count = (stage == :staging ? 1 : 2)
      run "cd #{current_path}; MINUTES_PER_FORK=5 QUEUE='*' COUNT=#{count} RAILS_ENV=#{stage} bundle exec rake resque:workers #{daemonized}"
    end

    desc "stop"
    task :stop, :roles => :resque_worker do
      kill_processes_matching "resque"
    end

    desc "restart"
    task :restart, :roles => :resque_worker do
      stop
      start
    end

    after "deploy:symlink", "resque:worker:restart"
  end
end


desc "copy database from production"
task :copy_database, :roles => :db do
  filename = "/tmp/sheriff_production.sql.gz"
  run "mysqldump sheriff_#{stage} -uroot | gzip > #{filename}"

  sh "scp #{ENV['USER']}@#{servers.first.host}:#{filename} #{filename}"
  sh "gunzip --stdout #{filename} | mysql sheriff_development -uroot"
end

def sh(command)
  raise "failed: #{command}" unless system(command)
end unless defined? sh

def kill_processes_matching(name, options={})
  not_matching = " | grep -v #{options[:not_matching]}" if options[:not_matching]
  run "ps -ef | grep #{name} | grep -v grep #{not_matching} | awk '{print $2}' | xargs --no-run-if-empty kill #{options[:signal]}"
end

def daemonized
  " > /dev/null 2>&1 &"
end

def servers
  find_servers_for_task(current_task)
end
