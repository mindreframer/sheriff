module ErrorLevelPropagation
  def self.included(base)
    base.class_eval do
      after_update :propagate_error_level_to_parent, :if => :current_error_level_changed?
    end
  end

  def propagate_error_level_to_parent
    parent = case self
    when Validation then report
    when Report then group
    when Group then group
    else raise
    end
    return unless parent
    parent.aggregate_error_level!
  end

  def aggregate_error_level!
    children = case self
    when Report then validations
    when Group then reports.presence || self.children
    else raise
    end
    max = (children.map(&:current_error_level).max || 0)
    update_attributes!(:current_error_level => max)
  end
end