require "safe_migrations"

RSpec.configure do |config|
  config.color_enabled = true
  config.backtrace_clean_patterns = [ ]
  config.mock_framework = :rr
end
