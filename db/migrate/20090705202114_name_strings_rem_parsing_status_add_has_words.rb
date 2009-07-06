class NameStringsRemParsingStatusAddHasWords < ActiveRecord::Migration
  def self.up
    remove_column :name_strings, :parsing_status
    add_column :name_strings, :has_words, :boolean
    #add_index :name_strings, :has_words, :name => 'idx_name_strings_3'
  end

  def self.down
    remove_column :name_strings, :has_words
    add_column :name_strings, :parsing_status, :integer
  end
end
