require './spec/spec_helper_fast'

describe Report do
  describe :report! do
    before do
      [Group, Report, Deputy, Validation].each(&:delete_all)
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
      report.reported_at.should be_within(3).of(Time.current)
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

    it "updates deputies last_report_at" do
      group = Factory(:group_l2)
      deputy = Factory(:deputy, :last_report_at =>10.minutes.ago)
      Report.report!('12', [group.group.name, group.name], :address => '123.123.123.123', :name => deputy.name)
      deputy.reload.last_report_at.should be_within(3).of(Time.current)
    end

    it "updates deputies name" do
      group = Factory(:group_l2)
      deputy = Factory(:deputy, :last_report_at =>10.minutes.ago, :name => 'old_name')
      Report.report!('12', [group.group.name, group.name], :address => deputy.address, :name => 'new_name')
      deputy.reload.name.should == 'new_name'
    end

    it "does not updates deputies name with blank" do
      group = Factory(:group_l2)
      deputy = Factory(:deputy, :last_report_at =>10.minutes.ago, :name => 'old_name')
      Report.report!('12', [group.group.name, group.name], :address => deputy.address, :name => '')
      deputy.reload.name.should == 'old_name'
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

    it "propagates error level" do
      report = Factory(:report)
      Factory(:value_validation, :value => 1, :error_level => 2, :report => report)
      Report.report!(111, [report.group.group.name, report.group.name], :address => report.deputy.address, :name => 'something')

      report.reload
      report.current_error_level.should == 2
      report.group.reload.current_error_level.should == 2
      report.group.group.reload.current_error_level.should == 2
    end

    it "removes error levels" do
      # failed validation
      group = Factory(:group_l2, :current_error_level => 3)
      report = Factory(:report, :group => group, :current_error_level => 3)
      validation = Factory(:value_validation, :value => 1, :current_error_level => 3, :error_level => 3, :report => report)

      # now ok again ...
      Report.report!(1, [report.group.group.name, report.group.name], :address => report.deputy.address, :name => 'something')
      report.reload

      report.validations.map(&:current_error_level).should == [0]
      report.current_error_level.should == 0
      report.group.reload.current_error_level.should == 0
      report.group.group.reload.current_error_level.should == 0
    end

    it "removes not all error levels" do
      # failed validation, one with 3, one with 2
      group = Factory(:group_l2, :current_error_level => 3)
      report = Factory(:report, :current_error_level => 3, :group => group)
      validation = Factory(:value_validation, :value => 1, :current_error_level => 3, :error_level => 3, :report => report)
      Factory(:report, :current_error_level => 2, :group => group)

      # report with 3 goes green againg ...
      Report.report!(1, [report.group.group.name, report.group.name], :address => report.deputy.address, :name => 'something')
      report.reload

      # group stays at 2
      report.validations.map(&:current_error_level).should == [0]
      report.current_error_level.should == 0
      report.group.reload.current_error_level.should == 2
      report.group.group.reload.current_error_level.should == 2
    end

    it "does not propagate unchanged error levels" do
      report = Factory(:report, :current_error_level => 3)
      validation = Factory(:value_validation, :value => 2, :error_level => 2, :current_error_level => 2, :report => report)
      Report.report!(1, [report.group.group.name, report.group.name], :address => report.deputy.address, :name => 'something')

      report.reload
      validation.current_error_level.should == 2
      report.current_error_level.should == 3
      report.group.reload.current_error_level.should == 0
      report.group.group.reload.current_error_level.should == 0
    end
  end

  describe :store_state_as_historic_value do
    it "creates a historic value from current state" do
      report = Factory(:report)
      lambda{
        report.store_state_as_historic_value
      }.should change(HistoricValue, :count).by(+1)
      historic = report.historic_values.last
      historic.value.should == report.value
      historic.reported_at.to_s.should == report.reported_at.to_s
    end
  end

  describe :delete do
    before do
      @report         = Factory(:report)
      @alert          = Factory(:alert, :report => @report)
      @validation     = Factory(:value_validation, :report => @report)
      @historic_value = Factory(:historic_value, :report => @report)
      @report.reload
    end

    it "sets deleted_at" do
      @report.deleted_at.should == nil
      @report.delete
      @report.deleted_at.should_not == nil
    end

    it "removes alerts" do
      @report.alerts.should == [@alert]
      @report.delete
      lambda{ @alert.reload}.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "removes historic values" do
      @report.historic_values.should == [@historic_value]
      @report.delete
      lambda{ @historic_value.reload}.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "calls deleted for validations" do
      @report.validations.should == [@validation]
      validation = @report.validations.first
      validation.should_receive(:delete)
      @report.delete
    end
  end
end
