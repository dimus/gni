class CreateDataSourceImportDetails < ActiveRecord::Migration
  def self.up
    create_table :data_source_import_details do |t|
      t.references :data_source_import
      t.references :name_string

      t.timestamps
    end

    add_index :data_source_import_details, [:data_source_import_id, :name_string_id], :name => 'idx_data_source_import_details_1'
  end

  def self.down
    drop_table :data_source_import_details
  end
end
