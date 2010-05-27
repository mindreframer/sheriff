require 'spec/spec_helper'

describe ReportsController do
  describe 'create' do
    before do
      Group.delete_all
      Report.delete_all
      Reporter.delete_all
    end

    def get_it
      get :create, :level1 => 'mysql', :level2 => 'memory', :level3 => 'swap', :value => '15'
    end

    it "creates a report if none exists" do
      lambda{get_it}.should change(Report, :count).by(+1)
    end

    it "creates a reporter if none exists" do
      lambda{get_it}.should change(Reporter, :count).by(+1)
    end

    it "creates groups if none exists" do
      lambda{get_it}.should change(Group, :count).by(+3)
    end
  end
end