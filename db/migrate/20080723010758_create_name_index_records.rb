class CreateNameIndexRecords < ActiveRecord::Migration
  def self.up
    create_table :name_index_records do |t|
      t.references :name_index
      t.references :kingdom
      t.string :rank
      t.string :local_id
      t.string :global_id
      t.string :url

      t.timestamps
    end

    add_index :name_index_records, :name_index, :name => 'idx_name_index_records_1'
  end

  def self.down
    drop_table :name_index_records
  end
end
