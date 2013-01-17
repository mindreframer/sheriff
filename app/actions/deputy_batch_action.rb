class DeputyBatchAction < BaseAction

  def perform
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

end