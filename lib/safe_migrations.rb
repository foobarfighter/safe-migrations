require "active_record"
require "benchmark"

require "safe_migrations/version"
require "safe_migrations/errors"
require "safe_migrations/migration_ext"

ActiveRecord::Migration.extend(SafeMigrations::MigrationExt::ClassMethods)
