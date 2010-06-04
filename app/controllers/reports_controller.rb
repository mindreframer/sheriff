class ReportsController < RestController
  layout 'group_sidebar'
  before_filter :convert_validation_interval, :remove_inactive_validations, :only => :update

  def create
    address, name = Deputy.extract_address_and_name(request)
    value = self.class.convert_value_from_params(params[:value])
    Report.report!(value, [params[:level1], params[:level2]], :name => name, :address => address)
    render :text => 'OK'
  end

  private

  def remove_inactive_validations
    (params[:report][:validations_attributes]||{}).each do |index, attributes|
      next if attributes.delete(:active)
      attributes[:_destroy] = true
    end
  end

  def convert_validation_interval
    (params[:report][:validations_attributes]||{}).each do |index, attributes|
      convert_interval attributes if attributes[:type] == 'RunEveryValidation'
    end
  end

  def collection
    @collection ||= Report.paginate(:page => params[:page], :per_page => 50, :include => [{:group => :group}, :deputy])
  end

  def self.convert_value_from_params(value)
    case value.to_s.strip
    when /^\d+$/ then value.to_i
    when /^\d+\.\d+$/ then value.to_f
    when /^['"](.+)['"]/ then $1
    else value
    end
  end
end