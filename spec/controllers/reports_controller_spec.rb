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
      put :update, :id => @report.id, :report => {:value_validation_attributes => {:active => true, :value_as_text => '1', :severity => '1'}}
      @report.reload.value_validation.value.should == 1
    end

    it "destroys a validation" do
      Factory(:value_validation, :report => @report)
      put :update, :id => @report.id, :report => {:value_validation_attributes => {:value_as_text => '1', :severity => '1'}}
      @report.reload.value_validation.should == nil
    end

    it "updates a validation" do
      old = Factory(:value_validation, :report => @report)
      put :update, :id => @report.id, :report => {:value_validation_attributes => {:active => true, :value_as_text => '1', :severity => '1', :id => old.id.to_s}}
      validation = @report.reload.value_validation
      validation.value.should == 1
      validation.id.should == old.id
    end

    it "converts an interval" do
      put :update, :id => @report.id, :report => {:run_every_validation_attributes => {:active => true, :interval_value => '3', :interval_unit => 1.day.to_s, :severity => '1'}}
      validation = @report.reload.run_every_validation
      validation.interval.should == 3.days
    end
  end
end