class AddOnlyRunOnceToValidation < ActiveRecord::Migration
  def self.up
    add_column :validations, :only_run_once, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :validations, :only_run_once, :boolean, :null => false, :default => false
  end
end
