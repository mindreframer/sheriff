class AlertsController < RestController
  hacky_respond_to :html, :xml, :json

  def delete_all
    Alert.delete_all
    redirect_to :action => :index
  end

  def collection
    @collection ||= begin
      r = resource_class.page(params[:page]).
        per(params[:per_page].presence || Alert.per_page).
        order(params[:order] || 'id desc').
        includes(:report => [{:group => :group}, :deputy])
      r = r.group(:report_id) if params[:unique]
      r
    end
  end
end
