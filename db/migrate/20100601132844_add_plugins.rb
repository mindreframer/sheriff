class AddPlugins < ActiveRecord::Migration
  def self.up
    create_table :plugins do |t|
      t.string :name, :null => false
      t.string :url
      t.text :code, :null => false
      t.timestamps
    end
    add_index :plugins, :name, :unique => true

    create_table :deputy_plugins do |t|
      t.integer :plugin_id, :deputy_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :plugins
    drop_table :deputy_plugins
  end
end
