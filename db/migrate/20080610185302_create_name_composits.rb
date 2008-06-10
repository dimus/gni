class CreateNameComposits < ActiveRecord::Migration
  def self.up
    create_table :name_composits do |t|
      t.references :name_canonical
      t.references :name_author_string
      t.references :name_year
      t.boolean :confirmed

      t.timestamps
    end
  end

  def self.down
    drop_table :name_composits
  end
end
