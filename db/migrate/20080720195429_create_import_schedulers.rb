class CreateImportSchedulers < ActiveRecord::Migration
  def self.up
    create_table :import_schedulers do |t|
      t.references :data_source
      t.string :status
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :import_schedulers
  end
end
