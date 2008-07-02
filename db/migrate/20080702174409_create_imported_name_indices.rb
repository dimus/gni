class CreateImportedNameIndices < ActiveRecord::Migration
  def self.up
    create_table :imported_name_indices do |t|
      t.references :name_string
      t.references :data_source
      t.references :response_format
      t.references :kingdom
      t.string :uri
      t.references :uri_type

      t.timestamps
    end
    add_index :imported_name_indices, [:data_source_id,:name_string_id], :name => "idx_imported_name_indices_1", :unique => true
  end

  def self.down
    remove_index :imported_name_indices, :name => :idx_imported_name_indices_1
    drop_table :imported_name_indices
  end
end
