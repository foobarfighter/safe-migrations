# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'safe_migrations/version'

Gem::Specification.new do |gem|
  gem.name          = "safe-migrations"
  gem.version       = SafeMigrations::VERSION
  gem.authors       = ["Bob Remeika"]
  gem.email         = ["bob.remeika@gmail.com"]
  gem.description   = %q{Assert rails migration safety at dev time}
  gem.summary       = %q{Protect yourself from migrations that are unsafe to run without downtime}
  gem.homepage      = "http://github.com/foobarfighter/safe-migrations"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rr"
  gem.add_development_dependency "rspec", "~> 3.0.0"
  gem.add_development_dependency "rake"
  gem.add_runtime_dependency     "activerecord", "~> 3.0.0"
end
