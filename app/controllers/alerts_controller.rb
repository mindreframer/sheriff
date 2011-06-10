class AlertsController < RestController
  hacky_respond_to :html, :xml, :json

  def delete_all
    Alert.delete_all
    redirect_to :action => :index
  end

  def collection
    @collection ||= resource_class.page(params[:page]).per(20).
      order(params[:order] || 'id desc').
      includes(:report => [{:group => :group}, :deputy])
  end
end
