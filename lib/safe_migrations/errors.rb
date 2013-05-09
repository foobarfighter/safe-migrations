module SafeMigrations
  class UnsafeMigration < StandardError
    GENERIC_BANNER = <<-BANNER
      You are running a migration that can be problematic unless you have
      taken the proper steps to ensure that it is successful.
    BANNER

    def intialize(message)
      super(GENERIC_BANNER + "\n" + message + "\n\n")
    end
  end

  class UnsafeAddColumn    < UnsafeMigration; end
  class UnsafeRemoveColumn < UnsafeMigration; end
end
