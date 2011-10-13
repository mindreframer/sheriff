class SettingsController < ApplicationController
  def index
    @settings = Settings.all
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
end
