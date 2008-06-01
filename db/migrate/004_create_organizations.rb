class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.string :identifier
      t.string :acronym
      t.string :logo_url
      t.string :description
      t.string :address
      t.float :decimal_latitude
      t.float :decimal_longitude
      t.string :related_information_url

      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
