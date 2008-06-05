class CreateNameIndices < ActiveRecord::Migration
  def self.up
    create_table :name_indices do |t|
      t.references :name_string
      t.references :data_source
      t.references :response_format
      t.references :kingdom
      t.string :uri
      t.references :uri_type
      t.datetime :created
      t.datetime :deleted

      t.timestamps
    end
  end

  def self.down
    drop_table :name_indices
  end
end
