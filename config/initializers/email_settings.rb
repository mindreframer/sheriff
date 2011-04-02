# Load mail configuration if not in test environment
unless Rails.env.test?
  mail_config = "config/email.yml"
  if File.exist?(mail_config) and email_settings = YAML::load_file("config/email.yml")[Rails.env]
    ActionMailer::Base.smtp_settings = email_settings
  end
end
