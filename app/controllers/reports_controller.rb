class ReportsController < RestController
  def create
    group = Group.find_or_create_for_level1(params[:level1])
    group = group.find_or_create_child(params[:level2])
    group = group.find_or_create_child(params[:level3])
    
    render :text => 'OK'
  end
end