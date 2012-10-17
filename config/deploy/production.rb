server_ip = '10.10.40.60'
role :app, server_ip
role :web, server_ip
role :resque_worker, server_ip
role :db, server_ip, :primary=>true

ssh_options[:keys] = "~/.ssh/deploy_id_rsa"
