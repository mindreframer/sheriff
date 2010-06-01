class DeputyPlugin < ActiveRecord::Base
  belongs_to :deputy
  belongs_to :plugin

  def plugin_name
    plugin.try(:name)
  end

  def plugin_name=(x)
    self.plugin = Plugin.find_by_name(x)
  end
end