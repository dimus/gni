class NameIndex < ActiveRecord::Base
  belongs_to :name_string
  belongs_to :kingdom
  belongs_to :data_source
  belongs_to :response_format
  belongs_to :uri_type
end
