class ParticipantContact < ActiveRecord::Base
  belongs_to :person
  belongs_to :participant_organization
end
