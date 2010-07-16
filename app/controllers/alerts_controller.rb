class AlertsController < RestController

  def delete_all
    Alert.all.each(&:destroy)
    redirect_to :action => :index
  end

  def collection
    @collection ||= resource_class.paginate(:per_page => 20, :page => params[:page], :order => 'id desc', :include => {:report => [{:group => :group}, :deputy]})
  end
end