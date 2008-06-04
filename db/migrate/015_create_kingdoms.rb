class CreateKingdoms < ActiveRecord::Migration
  def self.up
    create_table :kingdoms do |t|
      t.references :name_string

      t.timestamps
    end
  end

  def self.down
    drop_table :kingdoms
  end
end
