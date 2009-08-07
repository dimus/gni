class CreateNormalizedNameWords < ActiveRecord::Migration
  def self.up
    create_table :normalized_name_words do |t|
      t.references :name_word
      t.string :normalized
      t.string :phonetized
      t.string :normalized_first_letter, :limit => 1
      t.integer :normalized_length

      t.timestamps
    end
    add_index :normalized_name_words, :name_word_id, :name => 'idx_normalized_name_words_1'
    add_index :normalized_name_words, :normalized, :name => 'idx_normalized_name_words_2'
    add_index :normalized_name_words, :normalized_first_letter, :name => 'idx_normalized_name_words_3'
    add_index :normalized_name_words, :normalized_length, :name => 'idx_normalized_name_words_4'
  end

  def self.down
    drop_table :normalized_name_words
  end
end
