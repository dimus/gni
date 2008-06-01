class CreateOrganizationContacts < ActiveRecord::Migration
  def self.up
    create_table :organization_contacts do |t|
      t.integer :organization_id
      t.integer :person_id
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :organization_contacts
  end
end
