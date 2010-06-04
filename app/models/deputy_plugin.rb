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

  def code_for_deputy
    code = <<-CODE.unindent
      module TEMP_#{rand(1111111111111111)}
        def self.interval;#{interval};end
        _CODE_
      end
    CODE
    code.sub('_CODE_', plugin.code.gsub(/\r?\n/,"\n  "))
  end
end