class AlertsController < RestController
  hacky_respond_to :html, :xml, :json

  def health
    render :text => 'OK'
  end

  def delete_all
    Alert.delete_all
    redirect_to :action => :index
  end

  def collection
    @collection ||= begin
      r = resource_class.page(params[:page]).per(20).
        order(params[:order] || 'id desc').
        includes(:report => [{:group => :group}, :deputy])
      r = r.group(:report_id) if params[:unique]
      r
    end
  end
end
