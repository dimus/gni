class CreateNameIndices < ActiveRecord::Migration
  def self.up
    create_table :name_indices do |t|
      t.references :name_string 
      t.references :data_source
      t.string :records_hash #sha hash of the data from all name_index_records 

      t.timestamps
    end
    
    add_index :name_indices, [:data_source_id, :name_string_id], :name => "idx_name_indices_1", :unique => true
  end

  def self.down
    remove_index :name_indices, :name => :idx_name_indices_1
    drop_table :name_indices
  end
end
