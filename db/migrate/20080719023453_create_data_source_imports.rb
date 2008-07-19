class CreateDataSourceImports < ActiveRecord::Migration
  def self.up
    create_table :data_source_imports do |t|
      t.references :data_source
      t.string :action

      t.timestamps
    end
  end

  def self.down
    drop_table :data_source_imports
  end
end
