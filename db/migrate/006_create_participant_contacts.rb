class CreateParticipantContacts < ActiveRecord::Migration
  def self.up
    create_table :participant_contacts do |t|
      t.references :participant
      t.references :person
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :participant_contacts
  end
end
