class ValueValidation < Validation
  include SerializedValue

  belongs_to :report

  def value_as_text=(x)
    # rails or browser is stupid and converts text entered as "XXX" to XXX
    x = "'#{x}'" if x.to_s =~ /^[a-zA-Z]/
    self.value = eval(x) # this is evil, but dont tell anyone ok ?
  end

  def human_display
    "expects values #{value} (#{human_error_level})"
  end

  def check!
    matches = case value
    when Regexp then report.value.to_s =~ value
    when Array, Range then value.include?(report.value)
    else report.value == value
    end

    if matches
      validation_passed!
    else
      validation_failed! "Value did not match #{report.value.inspect} <-> #{value.inspect}"
    end
  end
end
