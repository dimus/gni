class TaxamatchersAddIndex < ActiveRecord::Migration
  def self.up
    add_index :taxamatchers, [:name_string_id1, :name_string_id2], :unique => true, :name => :idx_taxamatchers_1
  end

  def self.down
    remove_index :taxamatchers, :name => :idx_taxamatchers_1
  end
end
