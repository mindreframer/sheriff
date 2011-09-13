Sheriff::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false

  config.assets.compress = false # Do not compress assets
  config.assets.debug = true # Expands the lines which load the assets
end
