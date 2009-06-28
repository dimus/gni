class NameStringsRemoveParsedData < ActiveRecord::Migration
  def self.up
    remove_column :name_strings, :parsing_data
  end

  def self.down
    add_column :name_strings, :parsing_data, :text
  end
end
