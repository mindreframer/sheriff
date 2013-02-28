class ReportsController < RestController
  def create
    my_actions.create_report(request)
    render :text => 'OK'
  end

  def batch_validate
    my_actions.validate_reports
    redirect_back_or_default '/reports'
  end

  def update
    my_actions.update_report
    super
  end

  def clear_alerts
    my_actions.clear_alerts
    redirect_back_or_default '/reports'
  end

private

  def my_actions
    @my_action ||= ReportActions.new(params)
  end

  def collection
    params[:order] ||= 'id desc'
    scope = resource_class.visible
    @collection ||= scope.page(params[:page]).per(50).order(params[:order]).includes([{:group => :group}, :deputy, :validations])
  end
end
