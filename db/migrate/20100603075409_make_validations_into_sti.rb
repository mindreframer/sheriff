class MakeValidationsIntoSti < ActiveRecord::Migration
  def self.up
    create_table "validations" do |t|
      t.integer  "start_seconds",   :null => false, :default => 0
      t.integer  "end_seconds",   :null => false, :default => 0
      t.integer  "error_level", :null => false
      t.integer  "current_error_level", :null => false, :default => 0
      t.integer  "report_id", :null => false
      t.integer  "interval",   :null => false, :default => 0
      t.string "type", :null => false
      t.string   "value"
      t.timestamps
    end

    rename_column :alerts, :severity, :error_level
    
    drop_table :value_validations
    drop_table :run_every_validations
    drop_table :run_between_validations
  end

  def self.down
    drop_table :validations
    rename_column :alerts, :error_level, :severity
  end
end
