class DataSourcesAddNameStringsCountColumn < ActiveRecord::Migration
  def self.up
    add_column :data_sources, :name_strings_count, :integer, :default => 0
    add_index :name_index_records, [:kingdom_id], :name => :idx_name_index_records_3
    add_index :name_index_records, [:global_id], :name => :idx_name_index_records_4
  end

  def self.down
    remove_column :data_sources, :name_strings_count
    remove_index :name_index_records, :name => :idx_name_index_records_3
    remove_index :name_index_records, :name => :idx_name_index_records_4
  end
end
