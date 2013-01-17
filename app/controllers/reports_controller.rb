class ReportsController < RestController
  def create
    action = ReportActions.new(params)
    action.create_report(request)
    render :text => 'OK'
  end

  def batch_validate
    action = ReportActions.new(params)
    action.validate_reports
    redirect_back_or_default '/reports'
  end

  def update
    action = ReportActions.new(params)
    action.update_report
    super
  end

  def clear_alerts
    action = ReportActions.new(params)
    action.clear_alerts
    redirect_back_or_default '/reports'
  end

  private
  def collection
    params[:order] ||= 'id desc'
    @collection ||= Report.page(params[:page]).per(50).order(params[:order]).includes([{:group => :group}, :deputy, :validations])
  end
end
