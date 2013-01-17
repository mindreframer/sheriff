class HistoricValue < ActiveRecord::Base
  include SerializedValue

  # inline schema
  col :report_id,           :type => :integer, :null => false
  col :value,               :type => :string, :null => false
  col :reported_at,         :type => :datetime, :null => false
  col :current_error_level, :type => :integer, :default => 0, :null => false

  belongs_to :report
end