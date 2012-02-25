object @resource
attributes :id, :error_level, :message
child :report do
  attributes :id, :deputy_id
end
