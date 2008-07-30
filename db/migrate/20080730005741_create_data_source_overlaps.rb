class CreateDataSourceOverlaps < ActiveRecord::Migration
  def self.up
    create_table :data_source_overlaps do |t|
      t.integer :data_source_id_1, :null => false
      t.integer :data_source_id_2, :null => false
      t.float :strict_overlap

      t.timestamps
    end

    add_index :data_source_overlaps, [:data_source_id_1, :data_source_id_2], :name => 'idx_data_source_overlaps_1', :unique => true;
    add_index :data_source_overlaps, :data_source_id_1, :name => 'idx_data_source_overlaps_2'
    add_index :data_source_overlaps, :data_source_id_2, :name => 'idx_data_source_overlaps_3'
  end

  def self.down
    drop_table :data_source_overlaps
  end
end
