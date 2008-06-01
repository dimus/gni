class DataProvider < ActiveRecord::Base
  has_many :data_provider_roles
  belongs_to :data_source
  belongs_to :participant_organization
end
