class ReportsController < RestController
  layout 'group_sidebar'
  before_filter :convert_validation_interval, :remove_inactive_validations, :only => :update

  def create
    address, name = Deputy.extract_address_and_name(request)
    value = SerializedValue.convert_value_from_params(params[:value])
    Report.report!(value, params[:group].to_s.split('.',2), :name => name, :address => address)
    render :text => 'OK'
  end

  private

  def remove_inactive_validations
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