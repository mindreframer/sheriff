env = defined?(Rails.env) ? Rails.env : (ENV['RAILS_ENV'] || 'development')
CFG = YAML.load_file('config/config.yml')[env].with_indifferent_access.freeze
