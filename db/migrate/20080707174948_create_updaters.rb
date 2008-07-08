class CreateUpdaters < ActiveRecord::Migration
  def self.up
    create_table :updaters do |t|
      t.references :data_source
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :updaters
  end
end
