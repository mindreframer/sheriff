---
layout: default
title: Sheriff
github_name: sheriff
custom_install: true
nav:
  - name: What is sheriff?
    link: "#what"
  - name: Why
    link: "#why"
  - name: Reporting
    link: "#reporting"
  - name: Validations
    link: "#validations"
  - name: Dependencies
    link: "#dependencies"
---

### Sheriff is a web-based tool for server monitoring and reporting. {#what}  
 - keeps track of what was reported (historic values)
 - keeps track of who reported (hostname/ip)
 - distributes scout-compatible plugins to deputies (see [deputy](https://github.com/dawanda/deputy))
 - alerts via logging / email / sms when something goes wrong

### Reporting {#reporting}
Values get pushed to Sheriff via http get e.g. curl but preferably via [deputy](https://github.com/dawanda/deputy)

    curl myhost/notice?group=Cron.count_users&value=123
    deputy Cron.count_users 123

    # report the success/failure of script execution
    ./database_backup ; deputy Cron.db_backup $?


### Validations {#validations}
Sheriff validates reported values against a set of validations to see if someone should be notified.

 - ValueValidation -- reported value matches `'x', 1, 1..5, /foo/`
 - RunEveryValidation -- reported every 10 minutes / only once per day
 - RunBetweenValidation -- reported between 00:00 and 02:00


### Plugins {#plugins}
Plugins can be stored and assigned to deputies/servers to run every x minutes/hours/days.
These plugins are compatible to Scout, so you can use these [50+ existing plugins](https://github.com/highgroove/scout-plugins) or build your own.

    class Redis < Scout::Plugin
      def build_report
        report :memory => `/opt/redis/redis-cli info | grep used_memory: | sed s/used_memory://`.strip
      end
    end

### Summaries {#summaries}
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

### Cron
To notice when a report is missing we need a cron to check for it.

    * * * * * cd /srv/sheriff/current && RAILS_ENV=production ruby sh/cron_minute.rb && deputy Cron.sheriff


###  Dependencies {#dependencies}

* rubygems >= 1.3.1
