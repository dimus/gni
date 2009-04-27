class ImportNameIndexRecordAddDwcId < ActiveRecord::Migration
  def self.up
    add_column :import_name_index_records, :darwin_core_star_id, :string
    add_index :import_name_index_records, :darwin_core_star_id, :name => 'idx_import_name_index_records_2'
  end

  def self.down
    #removing column should delete index as well
    remove_column :import_name_index_records, :darwin_core_star_id
  end
end
