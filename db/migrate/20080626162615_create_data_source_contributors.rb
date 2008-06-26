class CreateDataSourceContributors < ActiveRecord::Migration
  def self.up
    create_table :data_source_contributors do |t|
      t.references :data_source
      t.references :user
      t.boolean :data_source_admin

      t.timestamps
    end
    
    add_index :data_source_contributors, [:data_source_id, :user_id], :name => "index_data_source_contributors1", :unique => true
  end

  def self.down
    remove_index :table_name, :name => :index_data_source_contributors1
    drop_table :data_source_contributors
  end
end
