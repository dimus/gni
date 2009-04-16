class KingdomsChangeColumns < ActiveRecord::Migration
  def self.up
    change_table :kingdoms do |t|
      t.string :name, :limit => 40
      t.remove :name_string_id
    end
  end

  def self.down
    change_table :kingdoms do |t|
      t.references :name_string
      t.remove :name
    end
  end
end
