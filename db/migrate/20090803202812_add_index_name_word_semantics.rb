class AddIndexNameWordSemantics < ActiveRecord::Migration
  def self.up
    add_index :name_word_semantics, :name_string_id, :name => 'idx_name_word_semantics_2'
  end

  def self.down
    remove_index :name_word_semantics, :name => 'idx_name_word_semantics_2'
  end
end
