class GroupsController < RestController
  hacky_respond_to :html, :xml, :json, :options => { :methods => :full_name }

  before_filter :add_conditions , :only => :index

  def resource
    @resource ||= @group ||= Group.find(params[:id], :include => {:reports => :validations}, :order => (params[:order] || :group_id))
  end
  
  
  def error_groups
    
  end
  
  
  def add_conditions
    params[:conditions] = params[:only_errors] ? "current_error_level > 0" : nil
  end
  
end