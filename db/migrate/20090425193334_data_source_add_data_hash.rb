class DataSourceAddDataHash < ActiveRecord::Migration
  def self.up
    add_column :data_sources, :data_hash, :string, :limit => 40 
  end

  def self.down
    remove_column :data_sources, :data_hash
  end
end
