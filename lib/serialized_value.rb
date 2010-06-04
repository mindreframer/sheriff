module SerializedValue
  def value
    real_value = read_attribute(:value)
    real_value ? YAML.load(real_value) : nil
  end

  def value=(x)
    write_attribute(:value, x.to_yaml)
  end
end