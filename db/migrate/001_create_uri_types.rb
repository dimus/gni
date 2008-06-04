class CreateUriTypes < ActiveRecord::Migration
  def self.up
    create_table :uri_types do |t|
      t.string :uri_type

      t.timestamps
    end
  end

  def self.down
    drop_table :uri_types
  end
end
