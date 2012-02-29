object @resource

common_attributes = [:id, :full_name]

attributes *common_attributes
child :children do
  attributes *common_attributes
end