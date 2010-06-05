class ValueValidation < Validation
  include SerializedValue
  
  belongs_to :report

  def value_as_text=(x)
    self.value = eval(x) # this is evil, but dont tell anyone ok ?
  end

  def check!
    matches = case value
    when Regexp then report.value.to_s =~ value
    when Array, Range then value.include?(report.value)
    else report.value == value
    end

    if matches
      update_attributes!(:current_error_level => 0)
    else
      update_attributes!(:current_error_level => error_level)
      Alert.create(:message => "Value did not match #{report.value.inspect} <-> #{value.inspect}", :error_level => error_level, :validation => self, :report => report)
    end
  end
end