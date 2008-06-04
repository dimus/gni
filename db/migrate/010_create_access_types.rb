class CreateAccessTypes < ActiveRecord::Migration
  def self.up
    create_table :access_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :access_types
  end
end
