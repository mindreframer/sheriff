class ReportsController < RestController
  before_filter :convert_validation_interval, :mark_inactive_validations_for_destroy, :only => [:update, :batch_validate]

  def create
    address, name = Deputy.extract_address_and_name(request)
    value = SerializedValue.convert_value_from_params(params[:value])
    Report.delayed_report(value, params[:group].to_s.split('.',2), {:name => name, :address => address})
    render :text => 'OK'
  end

  def batch_validate
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
    redirect_back_or_default '/reports'
  end

  private

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

  def collection
    @collection ||= Report.paginate(:page => params[:page], :per_page => 50, :order => 'id desc', :include => [{:group => :group}, :deputy, :validations])
  end
end