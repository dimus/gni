class CreateUniqueNames < ActiveRecord::Migration
  def self.up
    create_table :unique_names do |t|
      t.references :data_source
      t.references :name_string
      t.timestamps
    end    
    add_column :data_sources, :unique_names_count, :integer, :default => 0
    
    add_index :unique_names, [:data_source_id, :name_string_id], :name => 'idx_unique_names_1'
  end

  def self.down
    remove_column :data_sources, :unique_names_count
    drop_table :unique_names
  end
end
