=begin
  Schema of settings:

  > Settings.all #==>
  {
    "notifications"=>[
      {"name"=>"Name", "mail"=>"me@example.com", "phone_number"=>"01234339922"}
    ]
  }
=end

class KeyValue < ActiveRecord::Base
  col :key
  col :value, :type => :text
  add_index :key
end
KeyValue.auto_upgrade!

class Settings
  ALLOWED_KEYS = %w(notifications send_sms run_cron)

  def self.[](key)
    key = key.to_sym
    (KeyValue['settings'] || {})[key.to_s] if ALLOWED_KEYS.include?(key.to_s)
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
