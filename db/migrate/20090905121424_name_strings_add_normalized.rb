class NameStringsAddNormalized < ActiveRecord::Migration
  def self.up
    execute "alter table name_strings add column normalized varchar(255) character set ascii after name"

    add_index :name_strings, :normalized, :name => :idx_name_strings_3
  end

  def self.down
    remove_column :name_strings, :normalized
  end
end
