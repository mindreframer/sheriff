class AddLastReportAtToDeputies < ActiveRecord::Migration
  def self.up
    add_column :deputies, :last_report_at, :timestamp
  end

  def self.down
    remove_column :deputies, :last_report_at, :timestamp
  end
end
