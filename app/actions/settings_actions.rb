class SettingsActions < BaseAction
  def update_settings
    params[:settings].keys.each do |key|
      if key == "notifications"
        notifications = params[:settings][:notifications]
        notifications = notifications.reject{|n| n.values.include?("")}

        Settings[:notifications] = notifications
      else
        Settings[key.to_sym] = params[:settings][key.to_sym]
      end
    end
  end

  def test_settings
    SheriffMailer.test
    Sms.test
  end

  def reset_validation_errors
    # run every validation: report once
    validations = Validation.find(:all, :conditions => {:type => "RunEveryValidation"})
    validations.map(&:report).map(&:store_state_as_historic_value); nil
    # mark all as passed
    all = Validation.all
    all.each do |x|
      x.report.update_attributes!(:reported_at => Time.current)
      x.send(:validation_passed!)
    end ; nil
  end
end