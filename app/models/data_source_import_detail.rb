class DataSourceImportDetail < ActiveRecord::Base
  belongs_to :data_source_import
  belongs_to :name_string
end
