require 'spec/spec_helper'

describe GroupsController do
  describe :destroy do
    it "can destroy a parent" do
      group = Factory(:group_l2)
      children = group.children
      delete :destroy, :id => group.id
      Group.find_by_id(group.id).should == nil
      Group.find_all_by_id(children.map(&:id)).should == []
    end

    it "can destroy a group" do
      group = Factory(:group)
      delete :destroy, :id => group.id
      Group.find_by_id(group.id).should == nil
    end
  end
end