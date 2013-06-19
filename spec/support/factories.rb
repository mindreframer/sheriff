Factory.define(:group) do |f|
  f.sequence(:name){|n| "group-#{n}"}
end

Factory.define(:group_l2, :class => 'Group') do |f|
  f.sequence(:name){|n| "group2-#{n}"}
  f.association :group
end

Factory.define(:report) do |f|
  f.association :group, :factory => :group_l2
  f.association :deputy
  f.reported_at Time.current
  f.value '123'
end


Factory.define(:deputy) do |f|
  f.sequence(:name) {|n| "host#{n}.dawanda.com" }
  f.sequence(:address) {|n| "192.#{n}.#{rand(255)}.#{rand(255)}"}
end

Factory.define(:value_validation) do |f|
  f.association :report
  f.error_level 1
  f.value 22
end

Factory.define(:run_between_validation) do |f|
  f.association :report
  f.error_level 1
  f.start_seconds 60*60
  f.end_seconds 2*60*60
end

Factory.define(:run_every_validation) do |f|
  f.association :report
  f.error_level 1
  f.interval 60*60
end

Factory.define(:alert) do |f|
  f.error_level 1
  f.message 'Value did not match 1 <-> 0'
  f.validation_type 'Validation'
  f.association :validation, :factory => :value_validation
  f.association :report
end


Factory.define(:plugin) do |f|
  f.code "class Bla < Scout::Plugin;def build_report;puts 'fooo';end;end"
  f.sequence(:name){|n| "useless plugin #{n}#{rand(111111)}"}
end

Factory.define(:deputy_plugin) do |f|
  f.interval 5*60
  f.association :plugin
  f.association :deputy
end

Factory.define(:historic_value) do |f|
  f.association :report
  f.value rand(1111)
  f.reported_at Time.current
  f.current_error_level 1
end
