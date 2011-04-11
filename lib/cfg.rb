env = defined?(Rails.env) ? Rails.env : (ENV['RAILS_ENV'] || 'development')
config = if ENV['CONFIG.YML']
  require 'base64'
  Base64.decode64(ENV['CONFIG.YML'])
else
  File.read('config/config.yml')
end
CFG = YAML.load(config)[env].with_indifferent_access.freeze
