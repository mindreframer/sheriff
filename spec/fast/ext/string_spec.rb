require './spec/spec_helper_fast'
require './lib/ext/string'

describe String do
  describe 'to_bool' do
    it "parses truthy values" do
      %w[true t yes y 1].each do |word|
        word.to_bool.should == true
      end
    end

    it "parses falsy values" do
      %w[false f no n 0].each do |word|
        word.to_bool.should == false
      end
    end
  end
end