class CreateAccessRules < ActiveRecord::Migration
  def self.up
    create_table :access_rules do |t|
      t.integer :data_source_id
      t.integer :access_type_id
      t.boolean :is_allowed

      t.timestamps
    end
  end

  def self.down
    drop_table :access_rules
  end
end
