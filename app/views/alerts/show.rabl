object @resource
attributes :id, :error_level, :message, :created_at, :report_id, :validation_id

node :report do |m|
  partial("reports/show", :object => m.report)
end

node :deputy do |m|
  partial("deputies/show", :object => m.report.deputy)
end