class SettingsController < ApplicationController
  def index
    @settings = Settings.all
  end

  def update
    my_actions.update_settings
    redirect_to :action => :index
  end

  def test
    my_actions.test_settings
    redirect_to :action => :index
  end

  def reset
    my_actions.reset_validation_errors
    redirect_to :action => :index
  end

  def my_actions
    @my_action ||= SettingsActions.new(params)
  end
end
