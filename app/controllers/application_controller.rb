class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'group_sidebar'
  helper :all
  before_filter :authenticate if Rails.env.to_s == "production"

protected
  def authenticate
    if CFG[:user].present? and CFG[:password].present?
      authenticate_or_request_with_http_basic do |id, password|
        id == CFG[:user] && password == CFG[:password]
      end
    end
  end

  def redirect_back_or_default(*args)
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to *args
  end
end
