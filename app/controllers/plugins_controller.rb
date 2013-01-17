class PluginsController < RestController

  new! do |format|
    format.html{render 'edit'}
  end

  create! do |success, error|
    error.html{render 'edit'}
  end

  index! do |format|
    format.html{render 'index'}
    format.rb do
      render :text => my_actions.list_plugins_for_deputy(request)
    end
  end

private

  def my_actions
    @my_actions||= PluginActions.new(params)
  end

  def collection
    @collection ||= Plugin.page(params[:page]).per(50).order('name asc')
  end
end
