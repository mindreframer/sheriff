class RemoveDeputyUniqueNameIndex < ActiveRecord::Migration
  def self.up
    remove_index :deputies, :name
  end

  def self.down
    add_index :deputies, :name, :unique => true
  end
end
