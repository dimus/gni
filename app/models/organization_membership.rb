class OrganizationMembership < ActiveRecord::Base
  belongs_to :person
  belongs_to :organization
end
