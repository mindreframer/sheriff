require './spec/spec_helper_fast'

describe Plugin do
  describe "syntax checking" do
    it "warns on invalid syntax" do
      plugin = Factory.build(:plugin, :code => '<..asdsad<<<')
      plugin.save.should == false
      ruby_18 do
        plugin.errors.full_messages.join('').should include("compile error")
      end
      ruby_19 do
        plugin.errors.full_messages.join('').should include("syntax")
      end
    end

    it "accepts correct syntax" do
      plugin = Factory.build(:plugin, :code => '1+2')
      plugin.save!
    end

    ### not needed ATM
    # code_values = [
    #   ["puts 'hey'\r\n   \r\n    \r\n    \r\n    \r\n", "puts 'hey'\r\n"],
    #   ["\r\n    \r\n    \r\nputs 'hey'\r\n       \r\n", "\r\nputs 'hey'\r\n"],
    # ]

    # code_values.each_with_index do |values, i|
    #   it "removes newlines/spaces from the end of code nr. #{i}" do
    #     plugin = Factory.build(:plugin, :code => values[0])
    #     plugin.save!
    #     plugin.code.should == values[1]
    #   end
    # end
  end
end