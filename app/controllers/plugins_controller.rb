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
      action = PluginsForDeputyAction.new(params, request)
      render :text => action.perform
    end
  end

  def collection
    @collection ||= Plugin.page(params[:page]).per(50).order('name asc')
  end
end
