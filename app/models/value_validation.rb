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
    report_value = report.value
    result = check_against_value(report_value)
    if result
      validation_passed!
    else
      validation_failed! "Value did not match #{report.value.inspect} <-> #{value.inspect}"
    end
  end

  def check_against_value(report_value)
    report_value = convert_to_most_fitting_type(report_value)
    matches = case value
    when Regexp then report_value.to_s =~ value
    when Array, Range then value.include?(report_value)
    else report_value == value
    end
  end

  def convert_to_most_fitting_type(report_value)
    if report_value.to_s == report_value.to_i.to_s
      return report_value.to_i
    end
    report_value
  end
end
