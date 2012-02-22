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

    it "removes newlines/spaces from the end of code" do
      plugin = Factory.build(:plugin, :code => "puts 'hey'\r\n   \r\n    \r\n    \r\n    \r\n")
      plugin.save!
      plugin.code.should == "puts 'hey'" #
    end
  end
end