class AddHistoricValue < ActiveRecord::Migration
  def self.up
    create_table :historic_values do |t|
      t.integer :report_id, :null => false
      t.string :value, :null => false
      t.timestamp :reported_at, :null => false
    end
    add_index :historic_values, :report_id
  end

  def self.down
    drop_table :historic_values
  end
end
