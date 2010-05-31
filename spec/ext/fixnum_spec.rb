require 'spec/spec_helper'

describe Fixnum do
  describe :to_hms do
    it "is correct" do
      (13.hour + 14.minute + 15.seconds).to_hms.should == "13:14:15"
      (3.hour + 4.minute + 5.seconds).to_hms.should == "03:04:05"
    end
  end
end