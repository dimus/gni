class CreateOrganizationMemberships < ActiveRecord::Migration
  def self.up
    create_table :organization_memberships do |t|
      t.references :organization
      t.references :person
      t.string :job_title
      t.string :telephone
      t.string :address
      t.boolean :is_contact
      t.string :contact_role

      t.timestamps
    end
  end

  def self.down
    drop_table :organization_memberships
  end
end