class Organization < ActiveRecord::Base
  has_many :participant_organizations
  has_many :organization_contacts
end
