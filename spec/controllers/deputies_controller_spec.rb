require 'spec/spec_helper'

describe DeputiesController do
  describe 'update' do
    it "adds deputy_plugins" do
      deputy = Factory(:deputy)
      plugin = Factory(:plugin)
      lambda{
        put :update, :id => deputy.id, :deputy => {:deputy_plugins_attributes => {'0' => {:interval_value => 3, :interval_unit => 60, :plugin_name => plugin.name}}}
      }.should change(DeputyPlugin, :count).by(+1)
      DeputyPlugin.last.interval.should == 180
    end
  end
end