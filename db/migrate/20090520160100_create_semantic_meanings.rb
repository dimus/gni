class CreateSemanticMeanings < ActiveRecord::Migration
  def self.up
    create_table :semantic_meanings do |t|
      t.string :name
      t.timestamps
    end
    
    add_index :semantic_meanings, :name, :name => 'idx_semantic_meanings_1'
    execute "insert into semantic_meanings (name) values ('species epithet'), ('author'), ('year')"
  end

  def self.down
    drop_table :semantic_meanings
  end
end
