class ReportActions < BaseAction

  def validate_reports
    prepare_params
    reports = Report.find_all_by_id(params[:ids])
    reports.each do |report|
      if params[:overwrite]
        to_delete = validations_in_params.map do |attributes|
          next if attributes[:_destroy]
          report.validations.to_a.select{|v| v.class.to_s == attributes[:type] }
        end
        to_delete.flatten.compact.uniq.each(&:destroy)
      end
      report.update_attributes(params[:report])
    end
  end

  def create_report(request)
    address, name = Deputy.extract_address_and_name(request)
    value = SerializedValue.convert_value_from_params(params[:value])
    Report.delayed_report(value, params[:group].to_s.split('.',2), {:name => name, :address => address})
  end

  # this is just to clear the params.. delegates to super after it...
  def update_report
    prepare_params
  end

  def clear_alerts
    report = Report.find(params[:id])
    report.alerts.delete_all
  end

### private
  def prepare_params
    convert_validation_interval
    mark_inactive_validations_for_destroy
  end

  def mark_inactive_validations_for_destroy
    validations_in_params.each do |attributes|
      next if attributes.delete(:active)
      attributes[:_destroy] = true
    end
  end

  def convert_validation_interval
    validations_in_params.each do |attributes|
      convert_interval attributes if attributes[:type] == 'RunEveryValidation'
    end
  end

  def validations_in_params
    (params[:report][:validations_attributes]||{}).map{|index, attributes| attributes}
  end
end