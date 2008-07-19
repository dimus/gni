class CreateNameIndices < ActiveRecord::Migration
  def self.up
    create_table :name_indices do |t|
      t.references :name_string
      t.references :data_source
      t.references :response_format
      t.references :kingdom
      t.string :url
      t.string :local_id
      t.string :global_id
      t.datetime :created
      t.datetime :deleted

      t.timestamps
    end
    
    add_index :name_indices, [:data_source_id, :name_string_id], :name => "idx_name_indices_1", :unique => false
  end

  def self.down
    remove_index :name_indices, :name => :idx_name_indices_1
    drop_table :name_indices
  end
end
