class CreateDataProviderRoles < ActiveRecord::Migration
  def self.up
    create_table :data_provider_roles do |t|
      t.references :data_provider
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :data_provider_roles
  end
end
