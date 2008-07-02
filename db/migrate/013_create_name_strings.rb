class CreateNameStrings < ActiveRecord::Migration
  def self.up
    create_table :name_strings do |t|
      t.string   :name
      
      t.timestamps
    end
    
    add_index :name_strings, [:name], :name => "idx_name_strings_1", :unique => true
  end

  def self.down
    remove_index :name_strings, :name => :idx_name_strings_1
    drop_table   :name_strings
  end
end
