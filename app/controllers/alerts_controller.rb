class AlertsController < RestController
  layout 'group_sidebar'

  def collection
    @collection ||= resource_class.paginate(:per_page => 20, :page => params[:page], :order => 'id desc', :include => {:report => [{:group => :group}, :deputy]})
  end
end