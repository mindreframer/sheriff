class CreateKeyValue < ActiveRecord::Migration
  def self.up
    create_table :key_values do |t|
      t.string :key, :null => false
      t.text :value, :null => false
    end
    add_index :key_values, :key, :unique => true
  end

  def self.down
    drop_table :key_values
  end
end
