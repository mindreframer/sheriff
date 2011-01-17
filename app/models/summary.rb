class Summary < ActiveRecord::Base

  serialized_array :report_ids, :accessor => :report_ids_as_text

  DEFAULT_TIME_RANGE = 1.day

  def recent_historic_values
    HistoricValue.where(:report_id => report_ids).where("reported_at > ?", 2.day.ago).limit(100).order("reported_at desc")
  end

end
