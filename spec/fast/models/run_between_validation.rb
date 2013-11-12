require './spec/spec_helper_fast'

describe RunBetweenValidation do
  describe :check! do
    before do
      RunBetweenValidation.delete_all
      Alert.delete_all
      @validation = Factory(:run_between_validation)
      @reported = @validation.report.reported_at.seconds_after_midnight
    end

    it "does not warn when value is ok" do
      @validation.start_seconds = @reported - 1
      @validation.end_seconds = @reported + 1
      lambda{
        @validation.check!
      }.should_not change(Alert, :count)
    end

    it "warns when value is after" do
      @validation.end_seconds = @reported - 1
      @validation.start_seconds = @reported - 2
      lambda{
        @validation.check!
      }.should change(Alert, :count).by(+1)
      alert = Alert.last
      alert.validation.should == @validation
      alert.report.should == @validation.report
      alert.error_level.should == @validation.error_level
    end

    it "warns when value is before" do
      @validation.start_seconds = @reported + 1
      @validation.end_seconds = @reported + 2
      lambda{
        @validation.check!
      }.should change(Alert, :count).by(+1)
      alert = Alert.last
      alert.validation.should == @validation
      alert.report.should == @validation.report
      alert.error_level.should == @validation.error_level
    end
  end
end