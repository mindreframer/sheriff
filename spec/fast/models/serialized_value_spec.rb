require './spec/spec_helper_fast'

describe SerializedValue do
  describe 'convert_value_from_params' do
    [['123', 123], ["'123'", '123'], ["abc", "abc"], ['1.3', 1.3]].each do |source, converted|
      it "converts #{source} to #{converted}" do
        SerializedValue.convert_value_from_params(source).should == converted
      end
    end
  end
end