# Make build associations have their given type
# Before: Report.first.validations.build(:type=>ValueValidation).class == Validation
# After: Report.first.validations.build(:type=>ValueValidation).class == ValueValidation
class ActiveRecord::Reflection::AssociationReflection
  def build_association(*options, &block)
    if options.first.is_a?(Hash) and options.first[:type].presence
      options.first[:type].to_s.constantize.new(*options, &block)
    else
      klass.new(*options, &block)
    end
  end
end
