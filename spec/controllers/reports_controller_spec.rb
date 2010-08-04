require 'spec/spec_helper'

describe ReportsController do
  describe '#create' do
    before do
      Group.delete_all
      Report.delete_all
      Deputy.delete_all
    end

    def get_it(params={})
      get :create, params.merge(:group => 'mysql.connections', :value => '15')
      GenericJob.perform_all
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

    it "collects address from hostname" do
      get_it :hostname => 'my_host'
      Deputy.last.address.should == '0.0.0.0'
      Deputy.last.name.should == 'my_host'
    end
  end

  describe '#update' do
    let(:report){Factory(:report)}

    it "update" do
      put :update, :id => report.id, :report => {:value => 'xxx'}
      report.reload.value.should == 'xxx'
    end

    it "creates a validation" do
      put :update, :id => report.id, :report => {:validations_attributes => {0 => {:active => true, :value_as_text => '1', :error_level => '1', :type => 'ValueValidation'}}}
      report.reload.validations.first.value.should == 1
    end

    it "destroys a validation" do
      validation = Factory(:value_validation, :report => report)
      put :update, :id => report.id, :report => {:validations_attributes => {0 => {:value_as_text => '1', :error_level => '1', :type => 'ValueValidation', :id => validation.id}}}
      report.reload.validations.should == []
    end

    it "updates a validation" do
      validation = Factory(:value_validation, :report => report, :value => 3)
      put :update, :id => report.id, :report => {:validations_attributes => {0 => {:active => true, :value_as_text => '1', :error_level => '1', :id => validation.id.to_s, :type => 'ValueValidation'}}}
      validation.reload.value.should == 1
    end

    it "converts an interval" do
      put :update, :id => report.id, :report => {:validations_attributes => {0 => {:active => true, :interval_value => '3', :interval_unit => 1.day.to_s, :error_level => '1', :type => 'RunEveryValidation'}}}
      report.reload.validations.first.interval.should == 3.days
    end
  end

  describe '#batch_validate' do
    let(:reports){[Factory(:report), Factory(:report)]}

    it "adds validations in a batch" do
      post :batch_validate, :ids => reports.map(&:id), :report => {:validations_attributes => {0 => {:active => true, :interval_value => '3', :interval_unit => 1.day.to_s, :error_level => '1', :type => 'RunEveryValidation'}}}
      reports.each(&:reload).map{|r| r.validations.first.interval }.should == [3.days, 3.days]
    end

    it "removes old validations" do
      reports.each{|report| Factory(:run_every_validation, :report => report) }
      post :batch_validate, :ids => reports.map(&:id), :overwrite => true, :report => {:validations_attributes => {0 => {:active => true, :interval_value => '3', :interval_unit => 1.day.to_s, :error_level => '1', :type => 'RunEveryValidation'}}}
      reports.each(&:reload).map{|r| r.validations.map(&:interval) }.should == [[3.days], [3.days]]
    end
  end
end