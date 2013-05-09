class TestUnsafeRemoveColumn < ActiveRecord::Migration
  def self.up
    remove_column :some_table, :some_column
  end
end

class TestSafeRemoveColumn < ActiveRecord::Migration
  def self.up
    safety_assured { remove_column :some_table, :some_column }
  end
end
