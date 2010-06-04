class AddHumanNameToDeputies < ActiveRecord::Migration
  def self.up
    add_column :deputies, :human_name, :string
  end

  def self.down
    remove_column :deputies, :human_name, :string
  end
end
