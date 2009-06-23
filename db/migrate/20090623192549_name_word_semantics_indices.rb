class NameWordSemanticsIndices < ActiveRecord::Migration
  def self.up
    add_index :name_word_semantics, [:name_word_id, :name_string_id, :name_string_position], :unique => true, :name => 'idx_name_word_semantics_1'
  end

  def self.down
    remove_index :name_word_semantics, :name => 'idx_name_word_semantics_1'
  end
end
