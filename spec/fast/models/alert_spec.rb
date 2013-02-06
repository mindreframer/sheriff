require 'spec/spec_helper_fast'

class SheriffMailer
  # a dummy stub
end

describe Alert do
  before do
    Reporter.stub(:send_mail)
    Reporter.stub(:send_multi_mail)
    Alert.delete_all
    @alerts = [Alert.new(:message => "alert")]
  end
  describe :generate_alert_report do
    it "creates finds right alerts" do
      Alert.should_receive(:find).and_return([])
      Alert.generate_alert_report()
    end

    it "sends mail with error summary" do
      Alert.should_receive(:find).and_return(@alerts)
      Reporter.should_receive(:multi_notification).with(@alerts, anything)
      Alert.generate_alert_report()
    end

    it "also sends sms for alerts with high level errors" do
      email_alert = Alert.new(:message => "email alert", :error_level => 2)
      sms_alert   = Alert.new(:message => "sms alert", :error_level => 3)
      alerts      = [ email_alert, sms_alert]
      Alert.should_receive(:find).and_return(alerts)
      Reporter.should_receive(:send_sms).with(sms_alert)
      Alert.generate_alert_report()
    end
  end
end