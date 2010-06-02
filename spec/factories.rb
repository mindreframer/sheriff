Factory.define(:group) do |f|
  f.name rand(1000000)
end

Factory.define(:group_l2, :class => 'Group') do |f|
  f.name rand(1000000)
  f.association :group
end

Factory.define(:report) do |f|
  f.association :group, :factory => :group_l2
  f.association :deputy
  f.reported_at Time.current
  f.value '123'
end

Factory.define(:deputy) do |f|
  f.name 'c3.dawanda.com'
  f.address '192.168.2.23'
end

Factory.define(:value_validation) do |f|
  f.association :report
  f.severity 1
  f.value 22
end

Factory.define(:run_between_validation) do |f|
  f.association :report
  f.severity 1
  f.start_seconds 60*60
  f.end_seconds 2*60*60
end

Factory.define(:run_every_validation) do |f|
  f.association :report
  f.severity 1
  f.interval 60*60
end

Factory.define(:plugin) do |f|
  f.code "class Bla < Scout::Plugin;def build_report;puts 'fooo';end;end"
  f.name{ "useless plugin #{rand(111111111)}" }
end

Factory.define(:deputy_plugin) do |f|
  f.interval 5*60
  f.association :plugin
  f.association :deputy
end