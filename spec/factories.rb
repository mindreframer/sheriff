Factory.define(:group) do |f|
  f.name rand(1000000)
end

Factory.define(:group_l2, :class => 'Group') do |f|
  f.name rand(1000000)
  f.association :group
end

Factory.define(:report) do |f|
  f.association :group, :factory => :group_l2
  f.association :reporter
  f.reported_at Time.current
  f.value '123'
end

Factory.define(:reporter) do |f|
  f.name 'c3.dawanda.com'
  f.address '192.168.2.23'
end

Factory.define(:value_validation) do |f|
  f.association :report
  f.severity 1
  f.value 
end

Factory.define(:run_between_validation) do |f|
  f.association :report
  f.severity 1
  f.start_seconds 60*60
  f.end_seconds 2*60*60
end