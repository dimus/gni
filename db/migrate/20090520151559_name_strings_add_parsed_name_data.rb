class NameStringsAddParsedNameData < ActiveRecord::Migration
  def self.up
    change_table :name_strings do |t|
      t.integer :parsing_status
      t.text    :parsing_data
    end
    change_table :canonical_forms do |t|
      t.integer :first_letter, :limit => 1
      t.integer :length
    end
    
    add_index :canonical_forms, [:first_letter, :length], :name => 'idx_canonical_forms_2'    
  end

  def self.down
    
    remove_index :canonical_forms, :name => 'idx_canonical_forms_2'
    
    change_table :canonical_forms do |t|
      t.remove :length
      t.remove :first_letter
    end
    
    change_table :name_strings do |t|
      t.remove :parsing_data
      t.remove :parsing_status
    end
  end
end
