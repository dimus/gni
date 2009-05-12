class AddLexicalGroupsTables < ActiveRecord::Migration
  def self.up
    create_table :canonical_forms do |t|
      t.string :name
      t.timestamps
    end
    add_index :canonical_forms, :name, :name=> 'idx_canonical_forms_1', :unique => true
    add_column :name_strings, :canonical_form_id, :integer
    add_index :name_strings, :canonical_form_id, :name => 'idx_name_strings_2'
    
    create_table :lexical_groups do |t|
      t.integer :supercedure_id
      t.timestamps
    end
    
    create_table :lexical_group_name_strings do |t|
      t.references :name_string
      t.references :lexical_group
      t.timestamps
    end
    
    add_index :lexical_group_name_strings, [:name_string_id, :lexical_group_id], :name => 'idx_lexical_group_name_strings_1', :unique => true
    add_index :lexical_group_name_strings, :lexical_group_id, :name => 'idx_lexical_group_name_strings_2'
    
    create_table :name_strings_similarities do |t|
      t.integer :name_string_id_1
      t.integer :name_string_id_2
      t.integer :score
      t.timestamps
    end
  end

  def self.down
    drop_table :name_strings_similarities
    drop_table :lexical_group_name_strings
    drop_table :lexical_groups
    remove_column :name_strings, :canonical_form_id
    drop_table :canonical_forms
  end
end
