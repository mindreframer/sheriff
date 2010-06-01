class AddBaseModels < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name, :null => false
      t.integer :group_id
      t.timestamps
    end
    add_index :groups, [:group_id, :name], :unique => true

    create_table :reports do |t|
      t.integer :group_id, :deputy_id, :null => false
      t.string :value, :null => false
      t.string :config
      t.timestamps
    end
    add_index :reports, [:group_id, :deputy_id], :unique => true
    add_index :reports, :deputy_id

    create_table :deputies do |t|
      t.string :name, :address, :null => false
      t.timestamps
    end
    add_index :deputies, :name, :unique => true
    add_index :deputies, :address, :unique => true
  end

  def self.down
    drop_table :groups
    drop_table :reports
    drop_table :deputies
  end
end
