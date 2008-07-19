class CreateImportDetails < ActiveRecord::Migration
  def self.up
    create_table :import_details do |t|
      t.references :import
      t.references :name_string

      t.timestamps
    end
  end

  def self.down
    drop_table :import_details
  end
end
