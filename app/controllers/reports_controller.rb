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
    params[:report][:validations_attributes].each do |index, attributes|
      if attributes.delete(:active)
        type = attributes[:type].constantize
        if attributes[:id]
          type.find(params[:id]).update_attributes!(attributes)
        else
          type.create!(attributes.merge(:report => resource))
        end
      elsif attributes[:id]
        Validation.find(attributes[:id]).destroy
      end
      params[:report][:validations_attributes].delete(index)
    end
  end

  def convert_validation_interval
    convert_interval params[:report][:run_every_validation_attributes]
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