class CreateNameYears < ActiveRecord::Migration
  def self.up
    create_table :name_years do |t|
      t.integer :year
      t.string :unparsed

      t.timestamps
    end
  end

  def self.down
    drop_table :name_years
  end
end
