class Participant < ActiveRecord::Base
  has_many :participant_contacts
  has_one :data_provider
end

class ParticipantOrganization < Participant
  belongs_to :organzation
end

class ParticipantPerson < Participant
  belongs_to :person
end
