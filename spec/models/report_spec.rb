require 'spec/spec_helper'

describe Report do
  describe :report! do
    before do
      [Group, Report, Reporter].each(&:delete_all)
    end

    it "updates an existing report" do
      report = Factory(:report)
      Report.report!('12', [report.group.group.name, report.group.name], :address => report.reporter.address, :name => 'something')
      report.reload.value.should == '12'
    end

    it "creates a report if none exists" do
      group = Factory(:group_l2)
      reporter = Factory(:reporter)
      lambda{
        Report.report!('12', [group.group.name, group.name], :address => reporter.address, :name => 'something')
      }.should change(Report, :count).by(+1)
      report = Report.last
      report.value.should == '12'
      report.reported_at.should be_close(Time.current, 3)
    end

    it "creates a reporter if none exists" do
      group = Factory(:group_l2)
      lambda{
        Report.report!('12', [group.group.name, group.name], :address => '123.123.123.123', :name => 'something')
      }.should change(Reporter, :count).by(+1)
      Reporter.last.address.should == '123.123.123.123'
      Reporter.last.name.should == 'something'
    end

    it "find reporter by address" do
      group = Factory(:group_l2)
      reporter = Factory(:reporter)
      lambda{
        Report.report!('12', [group.group.name, group.name], :address => '123.123.123.123', :name => reporter.name)
      }.should change(Reporter, :count).by(0)
    end

    it "creates a groups if none exist" do
      reporter = Factory(:reporter)
      lambda{
        Report.report!('12', ['parent', 'child'], :address => reporter.address, :name => 'something')
      }.should change(Group, :count).by(+2)
      groups = Group.all(:limit => 2, :order => 'id desc').reverse
      groups.map(&:name).should == ['parent', 'child']
      groups[1].group.should == groups[0]
    end
  end
end