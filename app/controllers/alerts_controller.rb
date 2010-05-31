class AlertsController < RestController
  layout 'group_sidebar'

  def current_objects
    @current_objects = current_model.paginate(:per_page => 20, :page => params[:page], :order => 'id desc')
  end
end