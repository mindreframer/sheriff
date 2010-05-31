class AddReportedAtToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :reported_at, :timestamp, :null => false, :default => Time.at(0)
    change_column :reports, :reported_at, :timestamp, :default => nil
  end

  def self.down
    remove_column :reports, :reported_at
  end
end
