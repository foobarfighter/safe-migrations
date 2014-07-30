require File.dirname(__FILE__) + "/spec_helper"
require File.dirname(__FILE__) + "/migrations"

describe "SafeMigrations::MigrationExtTest" do
  before :all do
    # Get rid of migration stdout/stderr, e.g.
    # ==  TestSafeRemoveColumn: migrating ===========================================
    # ==  TestSafeRemoveColumn: migrated (0.0001s) ==================================
    ActiveRecord::Migration.verbose = false
  end

  describe "when there is no safety assurance" do
    it "should not let you run remove_column" do
      expect {
        TestUnsafeRemoveColumn.up
      }.to raise_error(SafeMigrations::UnsafeRemoveColumn)
    end

    it "should not let you run drop table" do
      expect {
        TestUnsafeDropTable.up
      }.to raise_error(SafeMigrations::UnsafeDropTable)
    end

    describe "add_index" do
      it "should fail without an algorithm specified" do
        expect {
          ActiveRecord::Migration.add_index(:some_table, :column)
        }.to raise_error(SafeMigrations::UnsafeAddIndex)
      end

      it "should fail with an algorithm other than :concurrently" do
        expect {
          ActiveRecord::Migration.add_index(:some_table, :column, :algorithm => :other)
        }.to raise_error(SafeMigrations::UnsafeAddIndex)
      end

      it "should work with algorithm == :concurrently" do
        mock(ActiveRecord::Migration).method_missing_without_safety(
          :add_index,
          anything,
          anything,
          anything
        )

        ActiveRecord::Migration.add_index(:some_table, :column, :algorithm => :concurrently)
      end
    end
  end

  describe "when there is safety assurance" do
    it "should let you run remove_column" do
      mock(TestSafeRemoveColumn).method_missing_without_safety(
          :remove_column,
          anything,
          anything
        )

      TestSafeRemoveColumn.up
    end

    it "should let you run drop_table" do
      mock(TestSafeDropTable).method_missing_without_safety(
          :drop_table,
          anything
        )

      TestSafeDropTable.up
    end
  end
end
