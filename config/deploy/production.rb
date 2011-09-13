role :app, "192.168.2.35"
role :web, "192.168.2.35"
role :resque_worker, "192.168.2.35"
role :db, "192.168.2.35", :primary=>true

ssh_options[:keys] = "~/.ssh/deploy_id_rsa"
