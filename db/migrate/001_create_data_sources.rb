class CreateDataSources < ActiveRecord::Migration
  def self.up
    create_table :data_sources do |t|
      t.string :title
      t.string :description
      t.string :rights
      t.string :citation
      t.string :metadata_url
      t.string :endpoint_url
      t.string :data_uri
      t.string :data_uri_type
      t.string :response_format
      t.integer :refresh_period_hours
      t.string :taxonomic_scope
      t.string :geospation_scope_wkt
      t.boolean :in_gni
      t.date :created
      t.date :updated

      t.timestamps
    end
  end

  def self.down
    drop_table :data_sources
  end
end
