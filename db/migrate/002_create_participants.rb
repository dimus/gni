class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.string :type
      t.integer :organization_id
      t.integer :person_id
      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
