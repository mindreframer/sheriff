require './spec/spec_helper_fast'

describe PluginActions do
  it "works" do
    a = PluginActions.new({})
    a.should be_instance_of(PluginActions)
  end
end