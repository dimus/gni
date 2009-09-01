class NameStringsAddIsCanonicalForm < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE name_strings ADD COLUMN is_canonical_form TINYINT AFTER name"
  end

  def self.down
    remove_column :name_strings, :is_canonical_form
  end
end
