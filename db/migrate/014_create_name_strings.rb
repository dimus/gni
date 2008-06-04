class CreateNameStrings < ActiveRecord::Migration
  def self.up
    create_table :name_strings do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :name_strings
  end
end
