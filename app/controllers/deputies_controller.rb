class DeputiesController < RestController
  before_filter :convert_plugin_interval, :only => [:update, :create]

  def batch
    action   = DeputyBatchAction.new(params)
    deputies = action.perform
    redirect_to :back, :notice => "Added #{deputies.size} plugins!"
  end

  def collection
    default_oder = ActiveRecord::Base.connection.class.concat_sql("COALESCE(human_name,'')", "name")
    params[:order] ||= default_oder
    @collection ||= resource_class.page(params[:page]).per(params[:per_page].presence || 40).order(params[:order])
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
