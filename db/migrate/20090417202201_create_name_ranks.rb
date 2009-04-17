class CreateNameRanks < ActiveRecord::Migration
  def self.up
    create_table :name_ranks do |t|
      t.string :name, :limit => 80
      t.timestamps
    end
    
    add_column :name_index_records, :name_rank_id, :integer
    execute("insert into name_ranks (select distinct null, rank, now(), now() from name_index_records where rank is not null) ")
    add_index :name_index_records, :name_rank_id, :name => :idx_name_index_records_5
    execute("update name_index_records nir join name_ranks nr on nr.name = nir.rank set name_rank_id = nr.id")
    remove_column :name_index_records, :rank
  end

  def self.down
    add_column :name_index_records, :rank, :string
    execute("update name_index_records nir join name_ranks nr on nr.id = nir.name_rank_id set rank = nr.name")
    remove_index :name_index_records, :name => :idx_name_index_records_5
    remove_column :name_index_records, :name_rank_id
    drop_table :name_ranks
  end
end
