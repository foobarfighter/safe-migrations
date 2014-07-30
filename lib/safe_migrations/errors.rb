module SafeMigrations
  class UnsafeMigration < StandardError
    GENERIC_BANNER = File.read(File.join(File.dirname(__FILE__), "..", "..", "banner.txt"))
    MIGRATION_SPECIFIC_MESSAGE_PLACEHOLDER = "<%= migration_specific_message %>"

    def initialize(message = "")
      banner_message = GENERIC_BANNER.gsub(MIGRATION_SPECIFIC_MESSAGE_PLACEHOLDER,
                                           migration_specific_message)
      super("#{banner_message}\n#{message}\n")
    end

    def migration_specific_message
      ''
    end
  end

  class UnsafeAddColumn    < UnsafeMigration; end

  class UnsafeRemoveColumn < UnsafeMigration
    def migration_specific_message
"ActiveRecord caches attributes which can cause problems
when removing columns, adding columns or changing column
names."
    end
  end

  class UnsafeAddIndex < UnsafeMigration
    def migration_specific_message
"ActiveRecord doesn't create indexes concurrently, so your table will be locked
against writes during index creation. Unless the table is very small, you
probably want to create it concurrently instead (use :algorithm => :concurrently).

Concurrent index creation cannot run inside a transaction (since it effectively
kicks off a background task in Postgres which can't really roll back) and all
Rails migrations run within one.  So you will need to manually commit prior to
adding the index, like so:

 def self.up
   commit_db_transaction
   add_index :sent_emails, [:to_user_id, :message_id], :algorithm => :concurrently
 end"
    end
  end
end
