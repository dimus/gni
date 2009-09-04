class CreateTaxamatchers < ActiveRecord::Migration
  def self.up
    create_table :taxamatchers do |t|
      t.integer :name_string_id1
      t.integer :name_string_id2
      t.integer :edit_distance
      t.float   :taxamatch_score
      t.integer :author_score
      t.boolean :matched
      t.boolean :algorithmic
      t.timestamps
    end
  end

  def self.down
    drop_table :taxamatchers
  end
end
