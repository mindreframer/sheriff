require 'spec/spec_helper_fast'

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

  describe :find_or_create_child do
    before do
      Group.delete_all
    end

    it "creates if non exists" do
      child = Factory(:group).find_or_create_child('xxx')
      child.name.should == 'xxx'
      child.should_not be_new_record
    end

    it "finds if exists" do
      group = Factory(:group, :name => 'xxx')
      child = Factory(:group, :name => 'xxx', :group => group)
      group.find_or_create_child('xxx').should == child
      Group.all.should =~ [group, child]
    end
  end
end