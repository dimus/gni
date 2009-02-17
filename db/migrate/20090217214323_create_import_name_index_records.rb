class CreateImportNameIndexRecords < ActiveRecord::Migration
  def self.up
    create_table :import_name_index_records do |t|
      t.references :data_source
      t.references :kingdom
      t.references :name_string
      t.string :name_string
      t.string :record_hash
      t.string :rank
      t.string :local_id
      t.string :global_id
      t.string :url

      t.timestamps
    end

    add_index :import_name_index_records, :name_string_id, :name => 'idx_import_name_index_records_1'
  end

  def self.down
    drop_table :import_name_index_records
  end
end
