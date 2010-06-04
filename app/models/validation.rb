class Validation < ActiveRecord::Base
  include ErrorLevelPropagation
  before_update :adjust_current_error_level

  protected

  def adjust_current_error_level
    self.current_error_level = error_level if error_level_changed? and current_error_level != 0
  end
end