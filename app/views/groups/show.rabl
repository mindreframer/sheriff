object @resource

common_attributes = ['id', 'name', 'current_error_level']

attributes *common_attributes
node :groups do |m|
  m.children.map{|c| c.attributes.slice(*common_attributes) }
end