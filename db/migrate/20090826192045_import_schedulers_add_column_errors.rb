class ImportSchedulersAddColumnErrors < ActiveRecord::Migration
  def self.up
    add_column :import_schedulers, :errors_list, :text
  end

  def self.down
    remove_column :import_schedulers, :errors_list
  end
end
