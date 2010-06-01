require 'spec/spec_helper'

describe Report do
  describe :report! do
    before do
      [Group, Report, Deputy].each(&:delete_all)
    end

    it "updates an existing report" do
      report = Factory(:report)
      Report.report!('12', [report.group.group.name, report.group.name], :address => report.deputy.address, :name => 'something')
      report.reload.value.should == '12'
    end

    it "creates a report if none exists" do
      group = Factory(:group_l2)
      deputy = Factory(:deputy)
      lambda{
        Report.report!('12', [group.group.name, group.name], :address => deputy.address, :name => 'something')
      }.should change(Report, :count).by(+1)
      report = Report.last
      report.value.should == '12'
      report.reported_at.should be_close(Time.current, 3)
    end

    it "creates a deputy if none exists" do
      group = Factory(:group_l2)
      lambda{
        Report.report!('12', [group.group.name, group.name], :address => '123.123.123.123', :name => 'something')
      }.should change(Deputy, :count).by(+1)
      Deputy.last.address.should == '123.123.123.123'
      Deputy.last.name.should == 'something'
    end

    it "find deputy by address" do
      group = Factory(:group_l2)
      deputy = Factory(:deputy)
      lambda{
        Report.report!('12', [group.group.name, group.name], :address => '123.123.123.123', :name => deputy.name)
      }.should change(Deputy, :count).by(0)
    end

    it "creates a groups if none exist" do
      deputy = Factory(:deputy)
      lambda{
        Report.report!('12', ['parent', 'child'], :address => deputy.address, :name => 'something')
      }.should change(Group, :count).by(+2)
      groups = Group.all(:limit => 2, :order => 'id desc').reverse
      groups.map(&:name).should == ['parent', 'child']
      groups[1].group.should == groups[0]
    end
  end
end