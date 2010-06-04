class AddIntervalToDeputyPlugins < ActiveRecord::Migration
  def self.up
    add_column :deputy_plugins, :interval, :integer, :null => false, :default => 60
    change_column :deputy_plugins, :interval, :integer, :default => nil
  end

  def self.down
    remove_column :deputy_plugins, :interval
  end
end
