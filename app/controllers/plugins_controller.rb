class PluginsController < RestController
  new! do |x|
    x.html{render 'edit'}
  end
  layout 'group_sidebar'
end