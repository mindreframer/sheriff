Sheriff::Application.configure do
  config.cache_classes = true
  config.whiny_nils = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection    = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # This config option was shown in the episode but is actually not used, so don't bother adding it.
  # config.assets.allow_debugging = true
end
