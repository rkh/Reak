if RUBY_ENGINE != 'rbx'
  warn "Seems like you're not running on Rubinius."
  warn "It's probably a good idea to change that."
elsif Rubinius::VERSION < '1.3'
  warn "You are using Rubinius #{Rubinius::VERSION}, you should probably use 1.3.0dev."
  warn "\nInstallation with RVM:"
  warn "  rvm install rbx-head-nhydra --branch hydra"
  warn "  rvm use rbx-head-nhydra"
  warn "\nMaybe it works anyways. If so, tell me."
  warn "You have been warned."
end
