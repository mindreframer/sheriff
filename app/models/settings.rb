class Settings
  BLOCKED_KEYS = %w(domain user password hoptoad_api_key).map(&:to_sym)
  ALLOWED_KEYS = %w(notifications)

  def self.[](key)
    key = key.to_sym
    (KeyValue['settings'] || {})[key.to_s] unless BLOCKED_KEYS.include?(key)
  end

  def self.[]=(key, value)
    settings = self.all
    settings.merge!({key.to_s => value})
    KeyValue['settings'] = settings
  end

  def self.all
    ALLOWED_KEYS.map do |key|
      [key, self[key.to_sym]]
    end.to_ordered_hash
  end
end
