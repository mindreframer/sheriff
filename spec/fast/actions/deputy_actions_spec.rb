require 'spec/spec_helper_fast'

describe DeputyActions do
  it "works" do
    a = DeputyActions.new({})
    a.should be_instance_of(DeputyActions)
  end


  describe :create_plugins_for_deputies do
    it "adds plugins to all" do
      plugin = Factory(:plugin)
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
  end
end