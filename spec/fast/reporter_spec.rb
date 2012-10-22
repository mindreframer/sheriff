require './spec/spec_helper_fast'
require './app/models/reporter'


describe Reporter do
  it "can be created" do
    Reporter.new.should_not be_nil
  end

  describe "single_notification" do
    before(:each) do
      @alert = OpenStruct.new(:error_level => 1)
    end

    it  "sends only email for level 2" do
      @alert.error_level = 2
      Reporter.should_receive(:send_mail).with(@alert)
      Reporter.should_not_receive(:send_sms).with(@alert)
      Reporter.single_notification(@alert)
    end

    it  "sends email AND SMS for level 3" do
      @alert.error_level = 3
      Reporter.should_receive(:send_mail).with(@alert)
      Reporter.should_receive(:send_sms).with(@alert)
      Reporter.single_notification(@alert)
    end
  end
end