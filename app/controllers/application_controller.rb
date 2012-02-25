class ApplicationController < ActionController::Base
  protect_from_forgery
  #layout 'group_sidebar'
  layout nil
  helper :all
  before_filter :authenticate if Rails.env == :production
  before_filter :intercept_html_requests



  private
  def intercept_html_requests
    render('layouts/dynamic') if request.format == Mime::HTML
  end

  def handle_unverified_request
    reset_session
    render "#{Rails.root}/public/500.html", :status => 500, :layout => nil
  end

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
