class Person < ActiveRecord::Base
  has_many :organization_contacts
  has_many :participant_contacts
  has_many :participant_people
end
