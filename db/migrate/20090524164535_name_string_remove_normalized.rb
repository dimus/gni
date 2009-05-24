class NameStringRemoveNormalized < ActiveRecord::Migration

  def self.up
    remove_index :name_strings, :name => 'idx_name_strings_1'
    remove_column :name_strings, :normalized_name
    add_index :name_strings, [:name], :name => 'idx_name_strings_1', :unique => true
  end

  def self.down
    remove_index :name_strings, :name => 'idx_name_strings_1'
    add_column :normalized_name, :normalized_name, :string
    add_index :name_strings, [:normalized_name], :name => 'idx_name_strings_1', :unique => true
  end

end
