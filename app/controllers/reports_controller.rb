class ReportsController < RestController
  layout 'group_sidebar'
  before_filter :convert_validation_interval, :add_or_remove_validations, :only => :update

  def create
    remote_host = request.remote_host.presence || "unknown_host_#{rand(1000000)}"
    Report.report!(params[:value], [params[:level1], params[:level2]], :address => request.ip, :name => remote_host)
    render :text => 'OK'
  end

  private

  def add_or_remove_validations
    Report::NESTED_VALIDATIONS.each do |validation_name|
      next unless params[:report][validation_name]
      validation = resource.send(validation_name)
      
      if params[:report][validation_name].delete(:active)
        if validation
          validation.attributes = params[:report][validation_name]
        else
          resource.send("build_#{validation_name}", params[:report][validation_name])
        end
      else
        validation.try(:destroy)
      end
      params[:report].delete(validation_name)
    end
  end

  def convert_validation_interval
    validation = params[:report][:run_every_validation] || return
    if validation[:interval_unit].present?
      validation[:interval] = validation[:interval_value].to_i * validation[:interval_unit].to_i
    end
    validation.delete :interval_value
    validation.delete :interval_unit
  end

  def collection
    @collection ||= Report.paginate(:page => params[:page], :per_page => 50, :include => [{:group => :group}, :reporter])
  end
end