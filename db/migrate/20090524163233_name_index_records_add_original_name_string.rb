class NameIndexRecordsAddOriginalNameString < ActiveRecord::Migration
  def self.up
      add_column :name_index_records, :original_name_string, :string
      add_column :import_name_index_records, :original_name_string, :string
  end

  def self.down
    change_table :name_index_records do |t|
      remove_column :import_name_index_records, :original_name_string
      remove_column :name_index_records, :original_name_string
    end
  end
end
