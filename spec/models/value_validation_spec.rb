require 'spec/spec_helper'

describe ValueValidation do
  describe :check! do
    before do
      ValueValidation.delete_all
      Alert.delete_all
      @validation = Factory(:value_validation, :value => 1, :report => Factory(:report, :value => 2))
    end

    it "warns when value does not match" do
      lambda{
        @validation.check!
      }.should change(Alert, :count).by(+1)
      alert = Alert.last
      alert.validation.should == @validation
      alert.report.should == @validation.report
      alert.severity.should == @validation.severity
    end

    it "does warns when value matches" do
      @validation.value = @validation.report.value
      lambda{
        @validation.check!
      }.should_not change(Alert, :count)
    end

    describe 'range' do
      it "warns when value does not match" do
        @validation.value = 1..1
        lambda{
          @validation.check!
        }.should change(Alert, :count).by(+1)
      end

      it "does warns when value matches" do
        @validation.value = 1..2
        lambda{
          @validation.check!
        }.should_not change(Alert, :count)
      end
    end

    describe 'array' do
      it "warns when value does not match" do
        @validation.value = [1,3]
        lambda{
          @validation.check!
        }.should change(Alert, :count).by(+1)
      end

      it "does warns when value matches" do
        @validation.value = [1,2]
        lambda{
          @validation.check!
        }.should_not change(Alert, :count)
      end
    end

    describe 'regex' do
      it "warns when value does not match" do
        @validation.value = /^1$/
        lambda{
          @validation.check!
        }.should change(Alert, :count).by(+1)
      end

      it "does warns when value matches" do
        @validation.value = /^2$/
        lambda{
          @validation.check!
        }.should_not change(Alert, :count)
      end
    end
  end
end