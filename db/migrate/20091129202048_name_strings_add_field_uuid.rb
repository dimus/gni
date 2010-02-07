class NameStringsAddFieldUuid < ActiveRecord::Migration
  def self.up
    execute "alter table name_strings add column uuid binary(16)"
    add_index :name_strings, :uuid, :name => "idx_name_strings_4" 
  end

  def self.down
    remove_column :name_strings, :uuid
  end
end
