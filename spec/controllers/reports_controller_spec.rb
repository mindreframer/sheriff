require 'spec/spec_helper'

describe ReportsController do
  describe 'create' do
    before do
      Group.delete_all
      Report.delete_all
      Deputy.delete_all
    end

    def get_it
      get :create, :level1 => 'mysql', :level2 => 'connections', :value => '15'
    end

    it "creates a report if none exists" do
      lambda{get_it}.should change(Report, :count).by(+1)
    end

    it "creates a deputy if none exists" do
      lambda{get_it}.should change(Deputy, :count).by(+1)
    end

    it "creates groups if none exists" do
      lambda{get_it}.should change(Group, :count).by(+2)
    end

    it "collects ip and address" do
      get_it
      Deputy.last.address.should == '0.0.0.0'
      Deputy.last.name.should =~ /unknown_host/
    end
  end

  describe ':update' do
    before do
      @report = Factory(:report)
    end

    it "update" do
      put :update, :id => @report.id, :report => {:value => 'xxx'} 
      @report.reload.value.should == 'xxx'
    end

    it "creates a validation" do
      put :update, :id => @report.id, :report => {:validations_attributes => {0 => {:active => true, :value_as_text => '1', :error_level => '1', :type => 'ValueValidation'}}}
      @report.reload.validations.first.value.should == 1
    end

    it "destroys a validation" do
      validation = Factory(:value_validation, :report => @report)
      put :update, :id => @report.id, :report => {:validations_attributes => {0 => {:value_as_text => '1', :error_level => '1', :type => 'ValueValidation', :id => validation.id}}}
      @report.reload.validations.should == []
    end

    it "updates a validation" do
      validation = Factory(:value_validation, :report => @report, :value => 3)
      put :update, :id => @report.id, :report => {:validations_attributes => {0 => {:active => true, :value_as_text => '1', :error_level => '1', :id => validation.id.to_s, :type => 'ValueValidation'}}}
      validation.reload.value.should == 1
    end

    it "converts an interval" do
      put :update, :id => @report.id, :report => {:validations_attributes => {0 => {:active => true, :interval_value => '3', :interval_unit => 1.day.to_s, :error_level => '1', :type => 'RunEveryValidation'}}}
      @report.reload.validations.first.interval.should == 3.days
    end
  end

  describe 'convert_value_from_params' do
    [['123', 123], ["'123'", '123'], ["abc", "abc"], ['1.3', 1.3]].each do |source, converted|
      it "converts #{source} to #{converted}" do
        ReportsController.convert_value_from_params(source).should == converted
      end
    end
  end
end