safe_migrations
===============

Assert rails migration safety at dev time.

blah blah blah


## Installation

Add this line to your application's Gemfile:

    gem 'safe_migrations'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install safe_migrations

## Usage

TODO: Write usage instructions here

To mark a step in the migration as safe, despite using method that might
otherwise be dangerous, wrap it in a `safety_assured` block, e.g.

```ruby
class MySafeMigration < ActiveRecord::Migration
  def self.up
    safety_assured { remove_column :foo_table, :foo_column }
  end
end
```

To override the safety check from the command line, without modifying the
migration code, set the `FORCE` environment variable.  This is useful when
running migrations in a development environment rather than on a production
server.
```
bundle exec rake db:migrate FORCE=t
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
