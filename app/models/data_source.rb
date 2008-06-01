class DataSource < ActiveRecord::Base
  has_many :data_providers
  has_many :access_rules
end
