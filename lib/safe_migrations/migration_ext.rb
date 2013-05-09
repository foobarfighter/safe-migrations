module SafeMigrations
  module MigrationExt
    module ClassMethods
      UNSAFE_METHODS = [:add_column, :remove_column, :rename_column]

      def self.extended(base)
        class << base
          alias_method_chain :method_missing, :safety
        end
      end

      def safety_assured(&block)
        @safety = true
        yield
      ensure
        @safety = false
      end

      def safe?
        !!@safety
      end

      def method_missing_with_safety(method, *args, &block)
        if safe? || !UNSAFE_METHODS.include?(method)
          return method_missing_without_safety(method, *args, &block)
        end

        case method
        when :remove_column
          raise UnsafeRemoveColumn
        end
      end
    end

  end
end
