class GroupsController < RestController
  layout 'group_sidebar'

  def resource
    @resource ||= @group ||= Group.find(params[:id], :include => {:reports => :validations}, :order => :group_id)
  end
end