class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  helper :all

  def convert_interval(h)
    if h[:interval_unit].present?
      h[:interval] = h[:interval_value].to_i * h[:interval_unit].to_i
    end
    h.delete :interval_value
    h.delete :interval_unit
  end
end