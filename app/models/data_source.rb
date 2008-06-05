class DataSource < ActiveRecord::Base
  has_many :data_providers
  has_many :access_rules
  has_many :name_indecies
  belongs_to :uri_type
  belongs_to :response_format
end
