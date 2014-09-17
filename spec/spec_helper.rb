require "safe_migrations"

RSpec.configure do |config|
  config.color = true
  config.backtrace_exclusion_patterns = [ ]
  config.mock_framework = :rr
end
