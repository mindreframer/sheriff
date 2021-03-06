class DeputyActions < BaseAction

  def create_plugins_for_deputies
    convert_interval params[:deputy_plugin]
    deputies = Deputy.find_all_by_id(params[:ids])
    deputies.each do |deputy|
      if params[:overwrite]
        deputy.deputy_plugins.select{|dp| dp.plugin_name == params[:deputy_plugin][:plugin_name] }.each(&:destroy)
      end
      deputy.deputy_plugins.create!(params[:deputy_plugin])
    end
    return deputies
  end

  def convert_plugin_interval
    values = params[:deputy][:deputy_plugins_attributes]
    return unless values
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