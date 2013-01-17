class DeputiesController < RestController
  before_filter :convert_plugin_interval, :only => [:update, :create]

  def batch
    deputies = my_actions.create_plugins_for_deputies
    redirect_to :back, :notice => "Added #{deputies.size} plugins!"
  end

private
  def collection
    default_oder = ActiveRecord::Base.connection.class.concat_sql("COALESCE(human_name,'')", "name")
    params[:order] ||= default_oder
    @collection ||= resource_class.page(params[:page]).per(params[:per_page].presence || 40).order(params[:order])
  end

  def my_actions
    @my_actions ||= DeputyActions.new(params)
  end

  # just delegate to actions class
  def convert_plugin_interval
    my_actions.convert_plugin_interval
  end
end
