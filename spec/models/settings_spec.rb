require 'spec/spec_helper'

describe Settings do
  before do
    Settings::ALLOWED_KEYS = %w(foo)
  end

  describe :[]= do
    it "should save stuff in settings" do
      Settings[:foo] = 'bar'
      KeyValue['settings']['foo'].should == 'bar'
    end
  end

  describe :[] do
    before do
      Settings[:foo] = [{:a => 'b', :c => 'd'}]
    end

    it "should be able to receive the correct values" do
      Settings[:foo].should == [{:c=>"d", :a=>"b"}]
    end
  end
end
