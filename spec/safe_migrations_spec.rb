require File.dirname(__FILE__) + "/spec_helper"

describe SafeMigrations::MigrationExt do
  describe "when there is no safety assurance" do
    it "should not let you run remove_column" do
      expect {
        ActiveRecord::Migration.remove_column :some_table, :some_column
      }.to raise_error(SafeMigrations::UnsafeRemoveColumn)
    end

    describe "rename_table" do
      it "should fail" do
        expect {
          ActiveRecord::Migration.rename_table :old_name, :new_name
        }.to raise_error(SafeMigrations::UnsafeRenameTable)
      end
    end

    describe "rename_column" do
      it "should fail" do
        expect {
          ActiveRecord::Migration.rename_column :old_name, :new_name
        }.to raise_error(SafeMigrations::UnsafeRenameColumn)
      end
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

    describe "change_table" do
      it "should fail" do
        expect {
          ActiveRecord::Migration.change_table do |t|
            t.index :column, :algorithm => :other
          end
        }.to raise_error(SafeMigrations::UnsafeChangeTable)

      end

      describe "t.index" do
        it "should fail with an algorithm other than :concurrently" do
          pending "Inspecting what happens in a change_table block is not currently supported"

          expect {
            ActiveRecord::Migration.change_table do |t|
              t.index :column, :algorithm => :other
            end
          }.to raise_error(SafeMigrations::UnsafeAddIndex)
        end
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

describe SafeMigrations::UnsafeRenameTable do
  describe "message" do
    let(:message) { subject.message }

    it "should include the banner text" do
      expect(message).to match(/You are running a migration that can be problematic/)
    end

    it "should give migration specific details" do
      expect(message).to match(/no way to rename a table without downtime/)
    end
  end
end

describe SafeMigrations::UnsafeRenameColumn do
  describe "message" do
    let(:message) { subject.message }

    it "should include the banner text" do
      expect(message).to match(/You are running a migration that can be problematic/)
    end

    it "should give migration specific details" do
      expect(message).to match(/no way to rename a column without downtime/)
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

describe SafeMigrations::UnsafeChangeTable do
  describe "message" do
    let(:message) { subject.message }

    it "should include the banner text" do
      expect(message).to match(/You are running a migration that can be problematic/)
    end

    it "should give migration specific details" do
      expect(message).to match(/cannot help you here/)
    end
  end
end
