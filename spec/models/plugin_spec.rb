require 'spec/spec_helper'

describe Plugin do
  describe "syntax checking" do
    it "warns on invalid syntax" do
      plugin = Factory.build(:plugin, :code => '<..asdsad<<<')
      plugin.save.should == false
      plugin.errors.full_messages.join('').should include("compile error")
    end

    it "accepts correct syntax" do
      plugin = Factory.build(:plugin, :code => '1+2')
      plugin.save!
    end
  end
end