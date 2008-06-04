class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.references :organization
      t.references :person
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
