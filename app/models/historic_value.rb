class HistoricValue < ActiveRecord::Base
  include SerializedValue
  belongs_to :report
end