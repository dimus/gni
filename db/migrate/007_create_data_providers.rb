class CreateDataProviders < ActiveRecord::Migration
  def self.up
    create_table :data_providers do |t|
      t.references :data_source
      t.references :participant
      t.timestamps
    end
  end

  def self.down
    drop_table :data_providers
  end
end
