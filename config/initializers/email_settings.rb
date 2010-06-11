# Load mail configuration if not in test environment
unless Rails.env.test?
  if email_settings = YAML::load(File.read("config/email.yml"))[Rails.env]
    ActionMailer::Base.smtp_settings = email_settings
  end
end