class DeputyPlugin < ActiveRecord::Base
  include IntervalAccessors

  validates_numericality_of :interval, :greater_than => 0
  validates_presence_of :plugin_id, :deputy_id

  belongs_to :deputy
  belongs_to :plugin

  def plugin_name
    plugin.try(:name)
  end

  def plugin_name=(x)
    self.plugin = Plugin.find_by_name(x)
  end
end