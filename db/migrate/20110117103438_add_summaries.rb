class AddSummaries < ActiveRecord::Migration
  def self.up
    create_table :summaries do |t|
      t.string :report_ids, :null => false
      t.string :name, :null => false
      t.timestamps
    end

  end

  def self.down
    drop_table :summaries
  end
end
