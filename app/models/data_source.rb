class DataSource < ActiveRecord::Base
  has_many :data_providers
  has_many :access_rules
  belongs_to :uri_type
  belongs_to :response_format
end
