class CreateNameCanonicals < ActiveRecord::Migration
  def self.up
    create_table :name_canonicals do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :name_canonicals
  end
end
