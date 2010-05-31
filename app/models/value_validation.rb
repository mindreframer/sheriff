class ValueValidation < ActiveRecord::Base
  belongs_to :report

  def value
    YAML.load(read_attribute(:value))
  end

  def value=(x)
    write_attribute(:value, x.to_yaml)
  end

  def value_as_text
    value.inspect
  end

  def value_as_text=(x)
    self.value = eval(x) # this is evil, but dont tell anyone ok ?
  end

  def check!
    matches = case value
    when Regexp then report.value.to_s =~ value
    when Array, Range then value.include?(report.value)
    else report.value == value
    end
    return if matches

    Alert.create(:message => "Value did not match #{report.value.inspect} <-> #{value.inspect}", :severity => severity, :validation => self, :report => report)
  end
end