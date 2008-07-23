class CreateImportSchedulers < ActiveRecord::Migration
  def self.up
    create_table :import_schedulers do |t|
      t.references :data_source
      t.string :status
      t.string :message

      t.timestamps
    end

    execute "alter table import_schedulers change column status status set('waiting', 'processing', 'failed', 'updated')"
  end

  def self.down
    drop_table :import_schedulers
  end
end
