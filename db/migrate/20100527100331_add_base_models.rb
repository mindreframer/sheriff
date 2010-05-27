class AddBaseModels < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name, :null => false
      t.integer :group_id
      t.timestamps
    end
    add_index :groups, :name, :unique => true
    add_index :groups, :group_id

    create_table :reports do |t|
      t.integer :group_id, :reporter_id, :null => false
      t.string :value, :null => false
      t.string :config
      t.timestamps
    end
    add_index :reports, [:group_id, :reporter_id], :unique => true
    add_index :reports, :reporter_id

    create_table :reporters do |t|
      t.string :name, :address, :null => false
      t.timestamps
    end
    add_index :reporters, :name, :unique => true
    add_index :reporters, :address, :unique => true
  end

  def self.down
  end
end
