Sheriff is a web-based tool for server monitoring and reporting.

 - keeps track of what was reported (historic values)
 - keeps track of who reported (hostname/ip)
 - distributes scout-compatible plugins to deputies (see [deputy](https://github.com/dawanda/deputy))
 - alerts via logging / email / sms when something goes wrong

### Reporting
Values get pushed to Sheriff via http get e.g. curl but preferably via [deputy](https://github.com/dawanda/deputy)

    curl myhost/notice?group=Cron.count_users&value=123
    deputy Cron.count_users 123

    # report the success/failure of script execution
    ./database_backup ; deputy Cron.db_backup $?

### Validations
Sheriff validates reported values against a set of validations to see if someone should be notified.

 - ValueValidation -- reported value matches `'x', 1, 1..5, /foo/`
 - RunEveryValidation -- reported every 10 minutes / only once per day
 - RunBetweenValidation -- reported between 00:00 and 02:00

### Plugins
Plugins can be stored and assigned to deputies/servers to run every x minutes/hours/days.
These plugins are compatible to Scout, so you can use these [50+ existing plugins](https://github.com/highgroove/scout-plugins) or build your own.

    class Redis < Scout::Plugin
      def build_report
        report :memory => `/opt/redis/redis-cli info | grep used_memory: | sed s/used_memory://`.strip
      end
    end

### Summaries
With summaries you can aggregate multiple reports, to e.g. compare responses.

### Resque
To keep Sheriff responsive, report processing should be queued in [Resque](https://github.com/defunkt/resque).<br/>
Install redis on localhost and set `resque: true` in config.yml<br/>

    # config.yml
    resque: true

If activated, Resque workers are started on `cap deploy` and Resque status can be seen at your-sheriff-url.com/resque/overview

### Hoptoad
Add hoptoad_api_key to config.yml to get errors reported to [Hoptoad](http://hoptoadapp.com).

### Newrelic
If you want performance analysis via [Newrelic](https://newrelic.com), add your `config/newrelic.yml`

# Demo / Heroku
You can play around with the demo at [sheriff.heroku.com](sheriff.heroku.com),
its public, so people will make crazy/dangerous plugins.<br/>
**Do not run plugins via deputy**.<br/>
Only ValueValidations work, since there are no cron jobs.

    # configure deputy via /etc/deputy.yml or ~/.deputy.yml
    sheriff_url: http://sheriff.heroku.com

    # report a value
    deputy Foo.bar 111

    # run plugins written by annonymouse pranksters
    deputy --run-plugins --no-wait

**To run your own setup**<br/>
Setup your heroku account

    git clone https://github.com/dawanda/sheriff.git
    cd sheriff
    heroku create my-sheriff

Make a config in config/config.heroku.yml

    sh/configure_heroku.rb
    git ps heroku

# Setup on normal server
Sheriff is Rails app deployed via capistrano. It needs:

 - Relational database (tested with MySql/Postgres)
 - Rack server (tested with passenger)
 - Mail setup in e.g. sheriff/shared/config/initializers/mail.rb
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
 - remove capistrano-ext dependency
 - make sms provider configurable (create a gem for that ?)
 - make 1.9 compatible
 - highlight and notify any new error/alert message <-> set them to default email -> user can adjust down
 - make plugin OPTIONS configurable
