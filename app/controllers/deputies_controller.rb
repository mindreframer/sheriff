class DeputiesController < RestController
  layout 'group_sidebar'
  before_filter :convert_plugin_interval, :only => [:update, :create]

  def convert_plugin_interval
    values = params[:deputy][:deputy_plugins_attributes]
    values.each do |key, value|
      if value[:plugin_name].blank? or value[:interval_value].to_i == 0
        DeputyPlugin.find(value[:id]).destroy if value[:id]
        values.delete key
      else
        convert_interval value
      end
    end
  end
end