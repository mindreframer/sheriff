Deputies report via /notice?group=#{name}&value=#{value} e.g. `curl myhost/notice?group=Cron.count_users&value=123` or just `deputy Cron.count_users 123`

### Cron
  * * * * * ruby /srv/sheriff/current/sh/cron_minute.rb && deputy Cron.sheriff 1