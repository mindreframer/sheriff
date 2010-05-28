class ReportsController < RestController
  layout 'group_sidebar'
  before_filter :convert_reporting_interval, :only => :update

  def create
    remote_host = request.remote_host.presence || "unknown_host_#{rand(1000000)}"
    Report.report!(params[:value], [params[:level1], params[:level2]], :address => request.ip, :name => remote_host)
    render :text => 'OK'
  end

  private

  def convert_reporting_interval
    report = params[:report]
    if report[:reporting_unit].present?
      report[:reporting_interval] = report[:reporting_value].to_i * report[:reporting_unit].to_i
    end
    report.delete :reporting_value
    report.delete :reporting_unit
  end

  def current_objects
    @reports ||= Report.paginate(:page => params[:page], :per_page => 50, :include => [{:group => :group}, :reporter])
  end
end