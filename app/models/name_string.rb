class NameString < ActiveRecord::Base
  has_one :kingdom
  has_many :name_indecies
  has_many :data_source_import_details
end
