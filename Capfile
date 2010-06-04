# PUBLIC  REPO,  DO  NOT  ADD  PASSWORDS
# PUBLIC  REPO,  DO  NOT  ADD  PASSWORDS
# PUBLIC  REPO,  DO  NOT  ADD  PASSWORDS
# PUBLIC  REPO,  DO  NOT  ADD  PASSWORDS
# PUBLIC  REPO,  DO  NOT  ADD  PASSWORDS
load 'deploy'

set :default_stage, "staging"
set :stages, %w(production staging)
require 'capistrano/ext/multistage'

set :application, "Sheriff"
set :scm, :git
set :repository, "git@github.com:dawanda/sheriff.git"
set :branch, "master"

set :deploy_to, '/srv/sheriff'

set :user, "deploy"
set :use_sudo, false

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_release} && touch tmp/restart.txt"
  end

  desc "Copy config files to config/"
  task :copy_config_files, :roles => [:app, :db] do
    run "cp #{deploy_to}/shared/config/*.yml #{current_release}/config/"
  end
  after 'deploy:update_code', 'deploy:copy_config_files'

  desc "add a file that tells us which env we are on"
  task :add_env do
    run "echo #{stage} > #{current_release}/env"
  end
  after 'deploy:update_code', 'deploy:add_env'
end

namespace :gems do
  task :bundle, :roles => :app do
    run "cd #{current_release} && bundle install --without test development"
  end
end
after 'deploy:update_code', 'gems:bundle'

namespace :fix do
  desc "update code and restart"
  task :update do
  end
  before 'fix:update', 'fix:update_without_restart'
  after  'fix:update', 'fix:restart'

  desc "update code without restart"
  task :update_without_restart do
    run "cd #{current_path} && git checkout . && git fetch origin #{branch} && git pull origin #{branch}"
  end
  after 'fix:update', 'deploy:copy_config_files'

  desc "simply restart app, no callbacks"
  task :restart, :roles => :app do
    run "cd #{current_path}; touch tmp/restart.txt"
  end
end