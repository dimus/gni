class CreateGlobalUniqueIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :global_unique_identifiers do |t|
      t.string :name
      t.timestamps
    end
    
    add_index :global_unique_identifiers, :name, :name => 'idx_global_unique_identifiers_1', :unique => true
    
    add_column :name_index_records, :global_unique_identifier_id, :integer
    add_column :import_name_index_records, :global_unique_identifier_id, :integer
    execute("insert into global_unique_identifiers (select distinct null, global_id, now(), now() from name_index_records where global_id is not null) ")
    execute("update name_index_records nir join global_unique_identifiers gui on gui.name = nir.global_id set global_unique_identifier_id = gui.id")
    remove_column :name_index_records, :global_id
    remove_column :import_name_index_records, :global_id
    add_index :name_index_records, :global_unique_identifier_id, :name => 'idx_name_index_records_3'
  end

  def self.down
    add_column :import_name_index_records, :global_id, :string
    add_column :name_index_records, :global_id, :string
    execute("update name_index_records nir join global_unique_identifiers gui on gui.id = nir.global_unique_identifier_id set global_id = gui.name")
    remove_column :import_name_index_records, :global_unique_identifier_id
    remove_column :name_index_records, :global_unique_identifier_id
    drop_table :global_unique_identifiers
  end
end
