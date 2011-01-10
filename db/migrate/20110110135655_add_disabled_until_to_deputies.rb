class AddDisabledUntilToDeputies < ActiveRecord::Migration
  def self.up
    add_column :deputies, :disabled_until, :datetime
  end

  def self.down
    remove_column :deputies, :disabled_until
  end
end
