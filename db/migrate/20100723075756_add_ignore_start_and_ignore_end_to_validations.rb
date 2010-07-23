class AddIgnoreStartAndIgnoreEndToValidations < ActiveRecord::Migration
  def self.up
    add_column :validations, :ignore_start, :string
    add_column :validations, :ignore_end, :string
  end

  def self.down
    remove_column :validations, :ignore_start_at
    remove_column :validations, :ignore_end_at
  end
end
