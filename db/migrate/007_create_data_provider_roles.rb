class CreateDataProviderRoles < ActiveRecord::Migration
  def self.up
    create_table :data_provider_roles do |t|
      t.integer :data_provider_id
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :data_provider_roles
  end
end
