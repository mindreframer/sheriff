require 'spec/spec_helper'

describe RunEveryValidation do
  describe :check! do
    before do
      RunEveryValidation.delete_all
      Alert.delete_all
      @validation = Factory(:run_every_validation)
      @validation.report.reported_at.seconds_after_midnight
      @buffer = 10
      @validation.stub!(:buffer).and_return @buffer
    end

    it "does not warn when value is ok" do
      @validation.report.reported_at = Time.now - @validation.interval / 2
      lambda{
        @validation.check!
      }.should_not change(Alert, :count)
    end

    it "warns when value is too late" do
      @validation.report.reported_at = Time.now - @validation.interval - 2 - @buffer
      lambda{
        @validation.check!
      }.should change(Alert, :count).by(+1)
      alert = Alert.last
      alert.validation.should == @validation
      alert.report.should == @validation.report
      alert.severity.should == @validation.severity
    end

    it "warns if multiple values where reported" do
      @validation.report.historic_values.create!(:value => '1', :reported_at => Time.current - @validation.interval.seconds + 1 + @buffer)
      @validation.report.reported_at = Time.current

      lambda{
        @validation.check!
      }.should change(Alert, :count).by(+1)
      alert = Alert.last
      alert.validation.should == @validation
      alert.report.should == @validation.report
      alert.severity.should == @validation.severity
    end

    it "does not warn if 1 value was reported" do
      @validation.report.historic_values.create!(:value => '1', :reported_at => Time.now - @validation.interval - 1 - @buffer)
      @validation.report.reported_at = Time.now
      lambda{
        @validation.check!
      }.should_not change(Alert, :count)
    end
  end

  describe :buffer do
    it "is 1.minute min" do
      RunEveryValidation.new(:interval => 1).buffer.should == 1.minute
    end

    it "is 30.minutes max" do
      RunEveryValidation.new(:interval => 10000000).buffer.should == 30.minutes
    end

    it "is 5% of interval" do
      RunEveryValidation.new(:interval => 20*10.minute).buffer.should == 10.minutes 
    end
  end
end