Sheriff is a web-based tool for server monitoring and reporting.

 - keeps track of what was reported (historic values)
 - keeps track of who reported (hostname/ip)
 - distributes scout-compatible plugins to deputies (see [deputy](https://github.com/dawanda/deputy))
 - alerts via logging / email / sms when something goes wrong

### Reporting
Values get pushed to Sheriff via http get e.g. curl but preferably via [deputy](https://github.com/dawanda/deputy)

    curl myhost/notice?group=Cron.count_users&value=123
    deputy Cron.count_users 123

### Validations
Sheriff validates reported values against a set of validations to see if someone should be notified.

 - ValueValidation -- reported value matches `'x', 1, 1..5, /foo/`
 - RunEveryValidation -- reported every 10 minutes / only once per day
 - RunBetweenValidation -- reported between 00:00 and 02:00

### Plugins
Plugins can be stored and assigned to deputies/servers to run every x minutes/hours/days.
These plugins are compatible to Scout, so you can use these [predefined](https://github.com/highgroove/scout-plugins) once or build your own.

    class Redis < Scout::Plugin
      def build_report
        report :memory => `/opt/redis/redis-cli info | grep used_memory: | sed s/used_memory://`.strip
      end
    end

### [Resque](https://github.com/defunkt/resque)
To keep Sheriff responsive, report processing should be queued in Resque.<br/>
Install redis on localhost and activate resque: true in config.yml<br/>

    # config.yml
    resque: true

Resque workers are then started when doing `cap deploy`.<br/>
Resque status can be seen at your-sheriff-url.com/resque/overview

### [Hoptoad](http://hoptoadapp.com/)
Add hoptoad_api_key to config.yml to get error reported to Hoptoad.

### [Newrelic](https://newrelic.com/)
If you want performance analysis, add your `config/newrelic.yml`

# Setup
Sheriff is Rails app deployed via capistrano. It needs:

 - Relational database (tested with MySql)
 - Rack server (tested with passenger)
 - mail server to send out mails
 - (Optional) Resque for higher responsiveness / no timeouts
 - (Optional) goyyamobile.com account for sms notifications
 - (Optional) Newrelic account for performance analysis
 - (Optional) Hoptoad account for error reporting

### Commands
For user 'deploy' group 'users' in /srv/sheriff

    # on server:
    sudo su
    cd /srv
    mkdir sheriff
    chown users:deploy -R sheriff

    sudo su deploy
    cd /srv/sheriff
    mkdir -p shared/config
    mkdir -p shared/log
    mkdir -p shared/pids
    --- add customized shared/config/config.yml + database.yml [+ newrelic.yml]
    --- to customize SMTP settings add shared/config/email.yml

    # from your box
    bundle exec cap deploy

### Server
Use anything rack-ish e.g. `passenger start [OPTIONS]`
    passenger start --port 3000 --address myhost.com --environment production --max-pool-size 1

or add via normal apache/nginx config.

### Logrotate
Dont let those log-files grow!

    sudo ln -s /srv/sheriff/current/config/logrotate /etc/cron.d/sheriff

### Cron
To notice when a report is missing we need a cron to check for it.

    * * * * * cd /srv/sheriff/current && RAILS_ENV=production ruby sh/cron_minute.rb && deputy Cron.sheriff

# TODO
 - make send_email flag do something...
 - remove capistrano-ext dependency
 - make email settings easier to configure
 - make sms provider configurable (create a gem for that ?)
 - make 1.9 compatible
 - highlight and notify any new error/alert message <-> set them to default email -> user can adjust down
 - make plugin OPTIONS configurable
