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
set :branch, ENV['BRANCH'] || "master"

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

  desc "Copy config files to config/"
  task :copy_config_files, :roles => [:app, :db] do
    run "cp #{deploy_to}/shared/config/* #{current_release}/config/"
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
      run "cd #{current_path}; MINUTES_PER_FORK=5 QUEUE='*' COUNT=#{count} RAILS_ENV=#{stage} rake resque:workers #{daemonized}"
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

def kill_processes_matching(name, options={})
  not_matching = " | grep -v #{options[:not_matching]}" if options[:not_matching]
  run "ps -ef | grep #{name} | grep -v grep #{not_matching} | awk '{print $2}' | xargs --no-run-if-empty kill #{options[:signal]}"
end

def daemonized
  " > /dev/null 2>&1 &"
end
