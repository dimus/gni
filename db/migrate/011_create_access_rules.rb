class CreateAccessRules < ActiveRecord::Migration
  def self.up
    create_table :access_rules do |t|
      t.references :data_source
      t.references :access_type
      t.boolean :is_allowed

      t.timestamps
    end
  end

  def self.down
    drop_table :access_rules
  end
end
