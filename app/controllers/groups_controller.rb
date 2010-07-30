class GroupsController < RestController

  def resource
    @resource ||= @group ||= Group.find(params[:id], :include => {:reports => :validations}, :order => (params[:order] || :group_id))
  end
end