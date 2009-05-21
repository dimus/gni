class CreateNameWords < ActiveRecord::Migration
  def self.up
    create_table :name_words do |t|
      t.string :word
      t.string :first_letter, :limit => 1
      t.integer :length

      t.timestamps
    end
    
    add_index :name_words, :word, :name => 'idx_name_words_1'
    add_index :name_words, [:first_letter, :length], :name => 'idx_name_words_2'
  end

  def self.down
    drop_table :name_words
  end
end
