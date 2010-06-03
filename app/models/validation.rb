class Validation < ActiveRecord::Base
  include ErrorLevelPropagation

  def attributes_protected_by_default
    super - [self.class.inheritance_column]
  end
end