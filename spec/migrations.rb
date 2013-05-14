class TestUnsafeDropTable < ActiveRecord::Migration
  def self.up
    drop_table :some_table
  end
end

class TestUnsafeRemoveColumn < ActiveRecord::Migration
  def self.up
    remove_column :some_table, :some_column
  end
end

class TestSafeDropTable < ActiveRecord::Migration
  def self.up
    safety_assured { drop_table :some_table }
  end
end

class TestSafeRemoveColumn < ActiveRecord::Migration
  def self.up
    safety_assured { remove_column :some_table, :some_column }
  end
end
