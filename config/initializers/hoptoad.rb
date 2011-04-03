if key = CFG[:hoptoad_api_key].presence
  require 'hoptoad_notifier'
  HoptoadNotifier.configure do |config|
    config.api_key = key
  end
end
