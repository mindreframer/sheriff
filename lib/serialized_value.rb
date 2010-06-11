module SerializedValue
  def value_as_text
    value.inspect
  end

  def value
    real_value = read_attribute(:value)
    real_value ? YAML.load(real_value) : nil
  end

  def value=(x)
    write_attribute(:value, x.to_yaml)
  end

  def self.convert_value_from_params(value)
    case value.to_s.strip
    when /^\d+$/ then value.to_i
    when /^\d+\.\d+$/ then value.to_f
    when /^['"](.+)['"]/ then $1
    else value
    end
  end
end