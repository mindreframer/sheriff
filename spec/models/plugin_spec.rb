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


    code_values = [
      ["puts 'hey'\r\n   \r\n    \r\n    \r\n    \r\n", "puts 'hey'\r\n"],
      ["\r\n    \r\n    \r\nputs 'hey'\r\n       \r\n", "\r\nputs 'hey'\r\n"],
    ]

    code_values.each_with_index do |values, i|
      it "removes newlines/spaces from the end of code nr. #{i}" do
        plugin = Factory.build(:plugin, :code => values[0])
        plugin.save!
        plugin.code.should == values[1]
      end
    end
  end
end