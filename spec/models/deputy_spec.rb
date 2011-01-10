require 'spec/spec_helper'

describe Deputy do
  describe :disabled? do
    it "is not disabled by default" do
      Factory(:deputy).disabled?.should == false
      Deputy.new.disabled?.should == false
    end

    it "is disabled when i turn it off" do
      deputy = Factory(:deputy, :disabled_until => 1.minute.from_now)
      deputy.disabled?.should == true
    end

    it "is not disabled when time ran out" do
      deputy = Factory(:deputy, :disabled_until => 1.minute.ago)
      deputy.disabled?.should == false
    end
  end
end