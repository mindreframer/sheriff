class DeputiesController < RestController
  layout 'group_sidebar'
  before_filter :convert_plugin_interval, :only => [:update, :create]

  def convert_plugin_interval
    values = params[:deputy][:deputy_plugins_attributes]
    values.reject! do |_, value|
      value[:plugin_name].blank? or value[:interval_value].blank?
    end
    convert_interval values
  end
end