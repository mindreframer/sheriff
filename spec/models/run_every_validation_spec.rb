require 'spec/spec_helper'

describe RunEveryValidation do
  describe :check! do
    before do
      RunEveryValidation.delete_all
      Alert.delete_all
      @validation = Factory(:run_every_validation)
      @validation.report.reported_at.seconds_after_midnight
    end

    it "does not warn when value is ok" do
      @validation.report.reported_at = Time.now - @validation.interval / 2
      lambda{
        @validation.check!
      }.should_not change(Alert, :count)
    end

    it "warns when value is too late" do
      @validation.report.reported_at = Time.now - @validation.interval - 2
      lambda{
        @validation.check!
      }.should change(Alert, :count).by(+1)
      alert = Alert.last
      alert.validation.should == @validation
      alert.report.should == @validation.report
      alert.severity.should == @validation.severity
    end

    it "warns if multiple values where reported" do
      @validation.report.historic_values.create!(:value => '1', :reported_at => Time.current - @validation.interval.seconds + 1)
      @validation.report.reported_at = Time.current - @validation.interval.seconds + 1

      lambda{
        @validation.check!
      }.should change(Alert, :count).by(+1)
      alert = Alert.last
      alert.validation.should == @validation
      alert.report.should == @validation.report
      alert.severity.should == @validation.severity
    end

    it "does not warn if 1 value was reported" do
      @validation.report.historic_values.create!(:value => '1', :reported_at => Time.now - @validation.interval - 2)
      @validation.report.reported_at = Time.now - @validation.interval + 1
      lambda{
        @validation.check!
      }.should_not change(Alert, :count)
    end
  end
end