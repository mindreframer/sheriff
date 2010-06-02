require 'spec/spec_helper'

describe PluginsController do
  describe 'index' do
    before do
      request.stub!(:remote_host).and_return 'x'
      request.stub!(:ip).and_return '1.2.3.4'
      Deputy.delete_all
      Plugin.delete_all
    end

    it "gives me my plugins" do
      dp = Factory(:deputy_plugin, :deputy => Factory(:deputy, :name => 'x'))
      plugin = dp.plugin
      get :index, :format => 'rb'
      response.body.strip.should include("# your plugins (name:x or address:1.2.3.4)")
      response.body.strip.should include(plugin.code)
    end

    it "gives me nothing when i am not recognised" do
      Factory(:deputy_plugin, :deputy => Factory(:deputy, :name => 'y'))
      get :index, :format => 'rb'
      response.body.should == '# you are not registered (name:x or address:1.2.3.4)'
    end

    it "gives me nothing when i have no plugins" do
      Factory(:deputy, :name => 'x')
      get :index, :format => 'rb'
      response.body.should == '# there are not plugins for you (name:x or address:1.2.3.4)'
    end
  end
end