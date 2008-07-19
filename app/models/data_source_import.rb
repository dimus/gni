class DataSourceImport < ActiveRecord::Base
  belongs_to :data_source
  has_many :data_source_import_details
end
