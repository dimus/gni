class CreateResponseFormats < ActiveRecord::Migration
  def self.up
    create_table :response_formats do |t|
      t.string :response_format

      t.timestamps
    end
  end

  def self.down
    drop_table :response_formats
  end
end
