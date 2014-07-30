require File.dirname(__FILE__) + "/spec_helper"

describe SafeMigrations::MigrationExt do
  describe "when there is no safety assurance" do
    it "should not let you run remove_column" do
      expect {
        ActiveRecord::Migration.remove_column :some_table, :some_column
      }.to raise_error(SafeMigrations::UnsafeRemoveColumn)
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
      mock(ActiveRecord::Migration).method_missing_without_safety(
          :remove_column,
          anything,
          anything
        )

       ActiveRecord::Migration.safety_assured do
         ActiveRecord::Migration.remove_column :some_table, :some_column
       end
    end

    it "should let you run add_index without an alogrithm specified" do
      mock(ActiveRecord::Migration).method_missing_without_safety(
          :add_index,
          anything,
          anything
        )

       ActiveRecord::Migration.safety_assured do
         ActiveRecord::Migration.add_index(:some_table, :column)
       end
    end
  end
end

describe SafeMigrations::UnsafeRemoveColumn do
  describe "message" do
    let(:message) { subject.message }

    it "should include the banner text" do
      expect(message).to match(/You are running a migration that can be problematic/)
    end

    it "should give migration specific details" do
      expect(message).to match(/removing columns/)
    end
  end
end


describe SafeMigrations::UnsafeAddIndex do
  describe "message" do
    let(:message) { subject.message }

    it "should include the banner text" do
      expect(message).to match(/You are running a migration that can be problematic/)
    end

    it "should give migration specific details" do
      expect(message).to match(/create it concurrently instead/)
    end
  end
end
