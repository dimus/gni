class NameIndicesAddIndex < ActiveRecord::Migration
  def self.up
    add_index :name_indices, [:data_source_id], :name => "idx_name_indices_2", :unique => true
  end

  def self.down
    remove_index :name_indices, :name => :idx_name_indices_2
  end
end
