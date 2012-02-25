class SettingsController < ApplicationController
  respond_to(:html, :json)
  def index
    @settings = Settings.all
    respond_to do |format|
      format.html
      format.json { render :json => @settings.to_json }
    end
  end

  def update
    params[:settings].keys.each do |key|
      if key == "notifications"
        notifications = params[:settings][:notifications]
        notifications = notifications.reject{|n| n.values.include?("")}

        Settings[:notifications] = notifications
      else
        Settings[key.to_sym] = params[:settings][key.to_sym]
      end
    end
    redirect_to :action => :index
  end

  def test
    Notifier.test
    Sms.test
    redirect_to :action => :index
  end

  def reset
    # run every validation: report once
    validations = Validation.find(:all, :conditions => {:type => "RunEveryValidation"})
    validations.map(&:report).map(&:store_state_as_historic_value); nil
    # mark all as passed
    all = Validation.all
    all.each do |x|
      x.report.update_attributes!(:reported_at => Time.current)
      x.send(:validation_passed!)
    end ; nil
    redirect_to :action => :index
  end
end
