unless defined? CFG
  CFG = CFGLoader.read "config/config.yml", "config/config.local.yml"
end