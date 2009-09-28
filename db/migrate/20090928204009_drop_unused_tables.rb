class DropUnusedTables < ActiveRecord::Migration
  def self.up
    drop_table :uri_types rescue nil
    drop_table :response_formats rescue nil
    drop_table :people rescue nil
    drop_table :access_rules rescue nil
    drop_table :access_types rescue nil
    drop_table :data_provider_roles rescue nil
    drop_table :data_providers rescue nil
    drop_table :participants rescue nil
    drop_table :participant_contacts rescue nil
    drop_table :organizations rescue nil
    drop_table :organization_memberships rescue nil
    drop_table :response_format rescue nil
  end

  def self.down
  end
end
