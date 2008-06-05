class CreateOrganizationContacts < ActiveRecord::Migration
  def self.up
    create_table :organization_contacts do |t|
      t.references :organization
      t.references :person
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :organization_contacts
  end
end
