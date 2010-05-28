class ReportsController < RestController
  def create
    Report.report!(params[:value], [params[:level1], params[:level2]], :address => request.ip, :name => request.remote_host)
    render :text => 'OK'
  end
end