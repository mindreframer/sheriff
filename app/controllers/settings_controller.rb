class SettingsController < ApplicationController
  def index
    @settings = Settings.all
  end

  def update
    Settings[:notifications] = params[:settings][:notifications]
    redirect_to :action => :index
  end
end
