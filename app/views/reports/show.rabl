object @resource
attributes :id, :group_id, :deputy_id, :value, :current_error_level

node do |u|
  { :deputy_name => u.deputy.name}
end
