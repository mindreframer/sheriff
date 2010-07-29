Deputies report via /notice?group=#{name}&value=#{value} e.g. `curl myhost/notice?group=Cron.count_users&value=123` or just `deputy Cron.count_users 123`

### Cron
    * * * * * RAILS_ENV=production cd /srv/sheriff/current && ruby sh/cron_minute.rb && deputy Cron.sheriff
