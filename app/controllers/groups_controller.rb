class GroupsController < RestController
  layout 'group_sidebar'

  def resource
    @group ||= Group.find(params[:id], :include => {:reports => :validations})
  end
end