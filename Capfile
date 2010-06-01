load 'deploy'

set :application, "Sheriff"
set :scm, :git
set :repository, "git@github.com:dawanda/sheriff.git"
set :branch, "master"

set :deploy_to, '/srv/sheriff'

set :user, "deploy"
ssh_options[:keys] = "~/.ssh/deploy_id_rsa"
set :use_sudo, false

role :app, "192.168.2.35"
role :web, "192.168.2.35"
role :db, "192.168.2.35", :primary=>true

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_release} && touch tmp/restart.txt"
  end

  desc "Copy config files to config/"
  task :copy_config_files, :roles => [:app, :db] do
    run "cp #{deploy_to}/shared/config/*.yml #{current_release}/config/"
  end
  after 'deploy:update_code', 'deploy:copy_config_files'
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
    run "cd #{current_path} && git fetch origin #{branch} && git pull origin #{branch}"
  end
  after 'fix:update', 'deploy:copy_config_files'

  desc "simply restart app, no callbacks"
  task :restart, :roles => :app do
    run "cd #{current_path}; touch tmp/restart.txt"
  end
end