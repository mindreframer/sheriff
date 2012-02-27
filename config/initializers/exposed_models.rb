Sheriff::EXPOSED_MODELS = [Alert, Deputy, Group, Plugin, Report, Settings].map do |m|
  {:model => m.name,
  :per_page => m.respond_to?('per_page') ? m.per_page : 50}
end
