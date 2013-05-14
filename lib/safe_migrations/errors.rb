module SafeMigrations
  class UnsafeMigration < StandardError
    GENERIC_BANNER = File.read(File.join(File.dirname(__FILE__), "..", "..", "banner.txt"))

    def initialize(message = "")
      super(GENERIC_BANNER + "\n#{message}\n")
    end
  end

  class UnsafeAddColumn    < UnsafeMigration; end
  class UnsafeRemoveColumn < UnsafeMigration; end
  class UnsafeDropTable    < UnsafeMigration; end
end
