class CreateNomenclaturalCodes < ActiveRecord::Migration
  def self.up
    create_table :nomenclatural_codes do |t|
      t.string :name, :limit => 40
      t.timestamps
    end
    
    add_column :name_index_records, :nomenclatural_code_id, :integer
    add_column :import_name_index_records, :nomenclatural_code_id, :integer
    
    add_index :nomenclatural_codes, :name, :name => 'idx_nomenclatural_codes_1'
    execute("insert into nomenclatural_codes values
      (null, 'ICBN', now(), now()),
      (null, 'ICZN', now(), now()),
      (null, 'BC', now(), now()),
      (null, 'ICNCP', now(), now()),
      (null, 'BioCode', now(), now())
    ")
  end

  def self.down
    remove_column :name_index_records, :nomenclatural_code_id
    remove_column :import_name_index_records, :nomenclatural_code_id

    drop_table :nomenclatural_codes
  end
end
