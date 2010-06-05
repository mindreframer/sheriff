class Validation < ActiveRecord::Base
  include ErrorLevelPropagation
  before_update :adjust_current_error_level

  protected

  def validation_failed!(message)
    if error_level != 0
      update_attributes!(:current_error_level => error_level)
      Alert.create(:message => message, :error_level => error_level, :validation => self, :report => report)
    else
      validation_passed!
    end
  end

  def validation_passed!
    update_attributes!(:current_error_level => 0) unless current_error_level == 0
  end

  def adjust_current_error_level
    self.current_error_level = error_level if error_level_changed? and current_error_level != 0
  end
end