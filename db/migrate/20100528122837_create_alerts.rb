class CreateAlerts < ActiveRecord::Migration
  def self.up
    remove_column :reports, :reporting_interval

    create_table :run_every_validations do |t|
      t.integer :interval, :null => false
      t.integer :severity, :null => false
      t.integer :report_id, :null => false
      t.timestamps
    end

    create_table :run_between_validations do |t|
      t.integer :start_seconds, :end_seconds, :null => false
      t.integer :severity, :null => false
      t.integer :report_id, :null => false
      t.timestamps
    end

    create_table :value_validations do |t|
      t.string :value, :null => false
      t.integer :severity, :null => false
      t.integer :report_id, :null => false
      t.timestamps
    end

    create_table :alerts do |t|
      t.integer :severity, :null => false
      t.string :message, :null => false
      t.integer :validation_id, :null => false
      t.string :validation_type, :null => false
      t.integer :report_id, :null => false
      t.timestamps
    end
  end

  def self.down
    add_column :reports, :reporting_interval, :integer
    drop_table :alerts
    drop_table :value_validations
    drop_table :run_between_validations
    drop_table :run_every_validations
  end
end
