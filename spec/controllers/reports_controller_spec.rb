require 'spec/spec_helper'

describe ReportsController do
  describe 'create' do
    before do
      Group.delete_all
      Report.delete_all
      Reporter.delete_all
    end

    def get_it
      get :create, :level1 => 'mysql', :level2 => 'connections', :value => '15'
    end

    it "creates a report if none exists" do
      lambda{get_it}.should change(Report, :count).by(+1)
    end

    it "creates a reporter if none exists" do
      lambda{get_it}.should change(Reporter, :count).by(+1)
    end

    it "creates groups if none exists" do
      lambda{get_it}.should change(Group, :count).by(+2)
    end

    it "collects ip and address" do
      get_it
      Reporter.last.address.should == '0.0.0.0'
      Reporter.last.name.should =~ /unknown_host/
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
      put :update, :id => @report.id, :report => {:value_validation => {:active => 'true', :value_as_text => '1', :severity => 1}}
      @report.reload.value_validation.value.should == 1
    end

    it "destroys a validation" do
      Factory(:value_validation, :report => @report)
      put :update, :id => @report.id, :report => {:value_validation => {:value_as_text => '1', :severity => 1}}
      @report.reload.value_validation.should == nil
    end

    it "updates a validation" do
      old = Factory(:value_validation, :report => @report)
      put :update, :id => @report.id, :report => {:value_validation => {:active => 'true', :value_as_text => '1', :severity => 1}}
      validation = @report.reload.value_validation
      validation.value.should == 1
      validation.id.should == old.id
    end
  end
end