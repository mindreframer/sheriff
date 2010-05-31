require 'spec/spec_helper'

describe Time do
  describe :seconds_after_midnight do
    it "is correct" do
      Time.parse("01:00:00").seconds_after_midnight.should == 1.hour
    end
  end
end