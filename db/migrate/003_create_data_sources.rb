class CreateDataSources < ActiveRecord::Migration
  def self.up
    create_table :data_sources do |t|
      t.string :title
      t.string :description
      t.string :logo_url
      t.string :data_url
      t.boolean :data_zip_compressed
      t.integer :refresh_period_days, :default => 14
      t.string :metadata_url
      # t.string :rights
      # t.string :citation
      # t.string :endpoint_url
      # t.string :data_uri
      # t.references :uri_type, :nill => true
      # t.references :response_format, :nill => true
      # t.string :taxonomic_scope
      # t.string :geospatial_scope_wkt
      # t.boolean :in_gni
      # t.date :created
      # t.date :updated

      t.timestamps
    end
  end

  def self.down
    drop_table :data_sources
  end
end
