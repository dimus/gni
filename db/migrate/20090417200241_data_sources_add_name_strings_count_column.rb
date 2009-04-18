class DataSourcesAddNameStringsCountColumn < ActiveRecord::Migration
  def self.up
    add_column :data_sources, :name_strings_count, :integer, :default => 0
  end

  def self.down
    remove_column :data_sources, :name_strings_count
  end
end
