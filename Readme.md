Deputies report via /notice?group=#{name}&value=#{value} e.g. `curl myhost/notice?group=Cron.count_users&value=123` or just `deputy Cron.count_users 123`

### Cron
    * * * * * cd /srv/sheriff/current && RAILS_ENV=production ruby sh/cron_minute.rb && deputy Cron.sheriff

# TODO
 - hightlight and notify any new error/alert message <-> set them to default email -> user can adjust down
