require 'spec/spec_helper'

describe Validation do
  def time_travel_to(time)
    old = Time.now
    now = time.to_time
    Time.stub!(:now).and_return now
    yield
    Time.stub!(:now).and_return old # unstub! does not work !?
  end

  describe :validations do
    let(:validation){ Factory.build(:value_validation) }

    it "is valid" do
      validation.valid?.should == true
    end

    it "is valid with ignore interval" do
      validation.ignore_start = '01:00'
      validation.ignore_end = '02:00'
      validation.valid?.should == true
    end

    it "is invalid with missing time" do
      validation.ignore_start = '01:00'
      validation.ignore_end = ''
      validation.valid?.should == false
    end

    it "is invalid with malformatted ignore interval" do
      validation.ignore_start = 'xx:00'
      validation.ignore_end = '02:00'
      validation.valid?.should == false
    end
  end

  describe :in_ignore_interval? do
    it "is not in ignore when nothing is set" do
      Validation.new.in_ignore_interval?.should == false
    end

    describe 'with simple interval' do
      let(:validation){Validation.new(:ignore_start => '01:00', :ignore_end => '01:01')}

      it "is ignored when in interval" do
        time_travel_to "2010-01-01 01:00:00" do
          validation.in_ignore_interval?.should == true
        end

        time_travel_to "2010-01-01 01:00:59" do
          validation.in_ignore_interval?.should == true
        end
      end

      it "is not in ignore when before interval" do
        time_travel_to "2010-01-01 00:59:59" do
          validation.in_ignore_interval?.should == false
        end
      end

      it "is not in ignore when after interval" do
        time_travel_to "2010-01-01 01:01:01" do
          validation.in_ignore_interval?.should == false
        end
      end
    end

    describe 'with overlapping interval' do
      let(:validation){Validation.new(:ignore_start => '23:00', :ignore_end => '01:00')}

      it "is ignored when in interval" do
        time_travel_to "2010-01-01 23:00:00" do
          validation.in_ignore_interval?.should == true
        end

        time_travel_to "2010-01-01 00:00:00" do
          validation.in_ignore_interval?.should == true
        end

        time_travel_to "2010-01-01 00:59:59" do
          validation.in_ignore_interval?.should == true
        end
      end

      it "is not in ignore when before interval" do
        time_travel_to "2010-01-01 22:59:59" do
          validation.in_ignore_interval?.should == false
        end
      end

      it "is not in ignore when after interval" do
        time_travel_to "2010-01-01 01:00:01" do
          validation.in_ignore_interval?.should == false
        end
      end
    end
  end
end