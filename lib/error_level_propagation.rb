module ErrorLevelPropagation
  def self.included(base)
    base.class_eval do
      after_update :propagate_error_level_to_parent, :if => :current_error_level_changed?
      after_destroy :propagate_error_level_to_parent
    end
  end

  def propagate_error_level_to_parent
    parents = case self
    when Validation then [report]
    when Report then [group, deputy]
    when Group then [group]
    when Deputy then []    
    else raise
    end
    parents.compact.each(&:aggregate_error_level!)
  end

  def aggregate_error_level!
    children = case self
    when Report then validations
    when Group then reports.presence || self.children
    when Deputy then reports
    else raise
    end
    max = (children.map(&:current_error_level).max || 0)
    update_attributes!(:current_error_level => max)
  end
end
