class AlertsController < RestController
  hacky_respond_to :html, :xml, :json

  def delete_all
    Alert.delete_all
    redirect_to :action => :index
  end

  def collection
    @collection ||= resource_class.page(params[:page]).per(params[:per_page]).all(
      :per_page => 20, :page => params[:page],
      :order => params[:order] || 'id desc',
      :include => {:report => [{:group => :group}, :deputy]}
    )
  end
end
