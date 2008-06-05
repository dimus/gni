class Organization < ActiveRecord::Base
  has_many :participant_organizations
  has_many :organization_contacts
  :class_name => "Person", :foreign_key => "person_id"
end
