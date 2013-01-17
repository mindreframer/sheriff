require 'spec/spec_helper_fast'

describe DeputyActions do
  it "works" do
    a = DeputyActions.new({})
    a.should be_instance_of(DeputyActions)
  end


  describe :create_plugins_for_deputies do
    it "adds plugins to all" do
      plugin   = Factory(:plugin)
      deputies = [Factory(:deputy), Factory(:deputy)]
      params = {
        :ids => deputies.map(&:id),
        :deputy_plugin => {
          :plugin_name    => plugin.name,
          :interval_value => 1,
          :interval_unit  => 1
        }
      }
      actions = DeputyActions.new(params)
      lambda{
        actions.create_plugins_for_deputies
      }.should change(DeputyPlugin, :count).by(+2)
      deputies.map(&:deputy_plugins).flatten.map(&:plugin_name).should == [plugin.name, plugin.name]
    end


    it "adds removes old plugins when asked" do
      to_keep   = Factory(:deputy_plugin)
      to_delete = Factory(:deputy_plugin)
      plugin_params = {
        :plugin_name    => to_delete.plugin_name,
        :interval_value => 1,
        :interval_unit  => 1
      }
      params = {
        :ids           => [to_delete.deputy_id, to_keep.deputy_id],
        :overwrite     => true,
        :deputy_plugin => plugin_params
      }
      actions = DeputyActions.new(params)
      lambda{
        actions.create_plugins_for_deputies
      }.should change(DeputyPlugin, :count).by(+1) # 2 new, 1 old removed
      DeputyPlugin.find_by_id(to_delete.id).should be_nil
      DeputyPlugin.find_by_id(to_keep.id).should_not be_nil
    end
  end
end