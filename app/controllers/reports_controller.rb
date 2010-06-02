class ReportsController < RestController
  layout 'group_sidebar'
  before_filter :convert_validation_interval, :remove_inactive_validations, :only => :update

  def create
    address, name = Deputy.extract_address_and_name(request)
    Report.report!(params[:value], [params[:level1], params[:level2]], :name => name, :address => address)
    render :text => 'OK'
  end

  private

  def remove_inactive_validations
    Report::NESTED_VALIDATIONS.each do |validation_name|
      attributes_name = "#{validation_name}_attributes"
      attributes = params[:report][attributes_name]

      next if not attributes or attributes.delete(:active)

      resource.send(validation_name).try(:destroy)
      params[:report].delete(attributes_name)
    end
  end

  def convert_validation_interval
    convert_interval params[:report][:run_every_validation_attributes]
  end

  def collection
    @collection ||= Report.paginate(:page => params[:page], :per_page => 50, :include => [{:group => :group}, :deputy])
  end
end