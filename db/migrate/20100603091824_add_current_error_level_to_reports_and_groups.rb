class AddCurrentErrorLevelToReportsAndGroups < ActiveRecord::Migration
  def self.up
    add_column :reports, :current_error_level, :integer, :null => false, :default => 0
    add_column :groups, :current_error_level, :integer, :null => false, :default => 0
    add_column :historic_values, :current_error_level, :integer, :null => false, :default => 0
    add_column :deputies, :current_error_level, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :reports, :current_error_level
    remove_column :groups, :current_error_level
    remove_column :historic_values, :current_error_level
    remove_column :deputies, :current_error_level
  end
end