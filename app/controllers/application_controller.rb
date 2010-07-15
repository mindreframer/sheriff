class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
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
    if Rails.env.production?
      authenticate_or_request_with_http_basic do |id, password|
        id == CFG[:user] && password == CFG[:password]
      end
    end
  end
end