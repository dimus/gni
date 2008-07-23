class NameIndex < ActiveRecord::Base
  belongs_to :name_string
  belongs_to :data_source
  has_many :name_index_records
end
