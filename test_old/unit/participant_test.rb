require File.dirname(__FILE__) + '/../test_helper'

class ParticipantTest < ActiveSupport::TestCase
  def setup
    @participants = Participant.find(:all)
    @john_part = participants(:participant_john)
    @nhm_part = participants(:participant_nhm)
  end
  
  def test_it_contains_organizations_and_people
    assert_not_nil(@participants.find {|p| p.is_a? Participant})
    assert_not_nil(@participants.find {|p| p.is_a? ParticipantOrganization})
    assert_not_nil(@participants.find {|p| p.is_a? ParticipantPerson})
  end
end
