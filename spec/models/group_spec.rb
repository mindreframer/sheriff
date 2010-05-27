require 'spec/spec_helper'

describe Group do
  describe :find_or_create_for_level1 do
    before do
      Group.delete_all
    end

    it "creates level1 if non exists" do
      Group.find_or_create_for_level1('xxx')
      Group.all.map(&:name).should == ['xxx']
    end

    it "find level 1 if exists" do
      group = Factory(:group, :name => 'xxx')
      parent = Factory(:group, :name => 'xxx', :group => group)
      Group.find_or_create_for_level1('xxx').should == group
      Group.all.should =~ [group, parent]
    end
  end
end