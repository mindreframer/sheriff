class ReportsController < RestController
  def create
    remote_host = request.remote_host.blank_to_nil || "unknown_host_#{rand(1000000)}"
    Report.report!(params[:value], [params[:level1], params[:level2]], :address => request.ip, :name => remote_host)
    render :text => 'OK'
  end

  private

  def current_objects
    @reports ||= Report.paginate(:page => params[:page], :per_page => 50, :include => [{:group => :group}, :reporter])
  end
end