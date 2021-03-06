class DeputyPlugin < ActiveRecord::Base
  include IntervalAccessors

  col :plugin_id,  :type => :integer,  :null => false
  col :deputy_id,  :type => :integer,  :null => false
  col :interval,   :type => :integer,  :null => false
  col :deleted_at, :type => :timestamp
  col_timestamps

  validates_numericality_of :interval, :greater_than => 0
  validates_presence_of :plugin_id, :deputy_id

  belongs_to :deputy
  belongs_to :plugin

  def self.visible
    self.where(:deleted_at => nil)
  end

  def plugin_name
    plugin.try(:name)
  end

  def plugin_name=(x)
    self.plugin = Plugin.find_by_name(x)
  end

  def delete
    self.update_attributes(:deleted_at => Time.current)
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