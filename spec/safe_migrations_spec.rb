require File.dirname(__FILE__) + "/spec_helper"
require File.dirname(__FILE__) + "/migrations"

describe "SafeMigrations::MigrationExtTest" do
  describe "when there is no safety assurance" do
    it "should not let you run remove_column" do
      lambda {
        TestUnsafeRemoveColumn.up
      }.should raise_error(SafeMigrations::UnsafeRemoveColumn)
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
  end
end
