class ApplicationController < ActionController::Base
  rescue_from Exception, :with => :render_simple_error if Rails.env.production?
  def render_simple_error(exception)
    render :text => "#{e.message} -- #{e.class}<br/>#{e.backtrace.join("<br/>")}"
  end


  protect_from_forgery
  layout 'group_sidebar'
  helper :all
  before_filter :authenticate

  def convert_interval(hash)
    return unless hash
    if hash[:interval_unit].present?
      hash[:interval] = hash[:interval_value].to_i * hash[:interval_unit].to_i
    end
    hash.delete :interval_value
    hash.delete :interval_unit
  end

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
