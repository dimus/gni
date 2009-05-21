class CreateNameWordSemantics < ActiveRecord::Migration
  def self.up
    create_table :name_word_semantics do |t|
      t.references :name_word
      t.references :name_string
      t.references :semantic_meaning
      t.integer :name_string_position
      t.timestamps
    end
  end

  def self.down
    drop_table :name_word_semantics
  end
end
