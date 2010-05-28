class AddReportingIntervalToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :reporting_interval, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :reports, :reporting_interval
  end
end
