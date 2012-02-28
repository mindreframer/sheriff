object @resource
attributes :id, :group_id, :deputy_id, :value, :current_error_level, :updated_at

node do |u|
  {
    :deputy_name => u.deputy.name,
    :group_full_name => u.group.full_name
  }
end