class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  helper :all

  def convert_interval(hash)
    return unless hash
    if hash[:interval_unit].present?
      hash[:interval] = hash[:interval_value].to_i * hash[:interval_unit].to_i
    end
    hash.delete :interval_value
    hash.delete :interval_unit
  end
end