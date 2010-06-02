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

  describe :value_as_text do
    [
    [1, "1"], ["1", '"1"'], [[1], "[1]"], [1..3, "1..3"], [/1/, "/1/"]
    ].each do |ruby, string|
      it "shows #{ruby.class}" do
        ValueValidation.new(:value => ruby).value_as_text.should == string
      end

      it "converts #{ruby.class}" do
        ValueValidation.new(:value_as_text => string).value.should == ruby
      end
    end
  end

  describe :value do
    it "is nil when nil" do
      ValueValidation.new.value.should == nil
    end
  end
end