class PluginsController < RestController
  layout 'application'
  new! do |format|
    format.html{render 'edit'}
  end

  create! do |success, error|
    error.html{render 'edit'}
  end

  index! do |format|
    format.html{render 'index'}
    format.rb do
      address, name = Deputy.extract_address_and_name(request)
      deputy = Deputy.find_by_address_or_name(address, name)
      info = "(name:#{name} or address:#{address})"
      text = if deputy
        if deputy.deputy_plugins.empty?
          "# there are not plugins for you #{info}"
        else
          "# your plugins #{info}\n" +
          deputy.deputy_plugins(:include => :plugin).map{|dp| "##{dp.plugin.name}\n#{dp.code_for_deputy}" }.join()
        end
      else
        "# you are not registered #{info}"
      end
      render :text => text
    end
  end
  layout 'group_sidebar'

  def collection
    @collection ||= Plugin.page(params[:page]).per(50).order('name asc')
  end
end
