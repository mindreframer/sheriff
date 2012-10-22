require './spec/spec_helper_fast'
require './app/models/reporter_fyrehose'

describe ReporterFyrehose do
  before  do
    @alert        = OpenStruct.new(:error_level => 2, :message => 'some message')
    @report       = OpenStruct.new()
    @group        = OpenStruct.new()
    @report.group = @group
    @alert.report = @report
  end

  it "can be created" do
    ReporterFyrehose.new.should_not be_nil
  end

  describe 'prio' do
    it "calculates prio" do
      @alert.error_level = 2
      ReporterFyrehose.alert_prio(@alert).should == "[CRITICAL]"
      @alert.error_level = 3
      ReporterFyrehose.alert_prio(@alert).should == "[DOOM]"
    end
  end

  describe 'send_alert' do
    it  "returns for low alerts (< 0)" do
      @alert.error_level = 0
      ReporterFyrehose.should_not_receive(:report)
      ReporterFyrehose.send_alert(@alert)
    end

    it  "reports for higher alerts (> 0)" do
      @alert.error_level = 1
      ReporterFyrehose.should_receive(:report)
      ReporterFyrehose.send_alert(@alert)
    end
  end
end