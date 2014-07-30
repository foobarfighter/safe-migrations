require File.dirname(__FILE__) + "/spec_helper"
require File.dirname(__FILE__) + "/migrations"

describe "SafeMigrations::MigrationExtTest" do
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
