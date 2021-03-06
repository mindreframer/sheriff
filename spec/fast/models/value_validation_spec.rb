require './spec/spec_helper_fast'

describe ValueValidation do
  describe :check! do
    before do
      ValueValidation.delete_all
      Alert.delete_all
      @validation = Factory(:value_validation, :value => 1, :report => Factory(:report, :value => 2))
    end

    it "creates alert when value does not match" do
      lambda{
        @validation.check!
      }.should change(Alert, :count).by(+1)
      alert = Alert.last
      alert.validation.should == @validation
      alert.report.should == @validation.report
      alert.error_level.should == @validation.error_level
    end
  end

  describe :check_against_value do
    before do
      @validation = Factory.build(:value_validation, :value => 1)
    end

    it "does not warn when value matches" do
      @validation.value = 1
      @validation.check_against_value(1).should == true
    end

    describe 'range' do
      it "warns when value does not match" do
        @validation.value = 1..1
        @validation.check_against_value(2).should be_false
      end

      it "does not warn when value matches" do
        @validation.value = 1..2
        @validation.check_against_value(2).should be_true
      end

      it "does not warn for negative integers, if in range" do
        @validation.value = -2..2
        @validation.check_against_value('-1').should be_true
      end
    end

    describe 'array' do
      it "warns when value does not match" do
        @validation.value = [1,3]
        @validation.check_against_value(2).should be_false
      end

      it "does warns when value matches" do
        @validation.value = [1,2]
        @validation.check_against_value(2).should be_true
      end
    end

    describe 'regex' do
      it "warns when value does not match" do
        @validation.value = /^1$/
        @validation.check_against_value(2).should be_false
      end

      it "does warns when value matches" do
        @validation.value = /^2$/
        @validation.check_against_value(2).should be_true
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

  describe :adjust_current_error_level do
    it "adjusts to new error level when in error state" do
      validation = Factory(:value_validation, :error_level => 2, :current_error_level => 2)
      validation.update_attributes(:error_level => 1)
      validation.current_error_level.should == 1
    end

    it "stays the same when not in error state" do
      validation = Factory(:value_validation, :error_level => 2, :current_error_level => 0)
      validation.update_attributes(:error_level => 1)
      validation.current_error_level.should == 0
    end
  end
end