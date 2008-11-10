class DataSourcesRemoveMetadata < ActiveRecord::Migration
  def self.up
    remove_column :data_sources, :metadata_url
    remove_column :data_zip_compressed
  end

  def self.down
    add_column :data_sources, :metadata_url, :string
    add_column :data_sources, :data_zip_compressed, :boolean
  end
end
