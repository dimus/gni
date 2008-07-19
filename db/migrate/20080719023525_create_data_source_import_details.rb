class CreateDataSourceImportDetails < ActiveRecord::Migration
  def self.up
    create_table :data_source_import_details do |t|
      t.references :data_source_import
      t.references :name_string

      t.timestamps
    end
  end

  def self.down
    drop_table :data_source_import_details
  end
end
