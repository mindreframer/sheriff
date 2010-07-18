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

  describe 'batch' do
    before do
      request.env['HTTP_REFERER'] = '/'
    end

    it "adds plugins to all" do
      plugin = Factory(:plugin)
      deputies = [Factory(:deputy), Factory(:deputy)]
      lambda{
        post :batch, :ids => deputies.map(&:id), :deputy_plugin => {:plugin_name => plugin.name, :interval_value => 1, :interval_unit => 1}
      }.should change(DeputyPlugin, :count).by(+2)
      deputies.map(&:deputy_plugins).flatten.map(&:plugin_name).should == [plugin.name, plugin.name]
    end

    it "adds removes old plugins when asked" do
      to_keep = Factory(:deputy_plugin)
      to_delete = Factory(:deputy_plugin)
      plugin_params = {:plugin_name => to_delete.plugin_name, :interval_value => 1, :interval_unit => 1}
      lambda{
        post :batch, :ids => [to_delete.deputy_id, to_keep.deputy_id], :overwrite => true, :deputy_plugin => plugin_params
      }.should change(DeputyPlugin, :count).by(+1) # 2 new, 1 old removed
      lambda{to_delete.reload}.should raise_error(ActiveRecord::RecordNotFound)
      to_keep.reload
    end
  end
end