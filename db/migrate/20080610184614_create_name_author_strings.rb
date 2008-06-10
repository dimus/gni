class CreateNameAuthorStrings < ActiveRecord::Migration
  def self.up
    create_table :name_author_strings do |t|
      t.string :author_string

      t.timestamps
    end
  end

  def self.down
    drop_table :name_author_strings
  end
end
