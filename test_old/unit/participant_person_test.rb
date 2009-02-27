require File.dirname(__FILE__) + '/../test_helper'

class ParticipantPersonTest < ActiveSupport::TestCase
  def setup
    @participants = ParticipantPerson.find(:all)
    @part_john = participants(:participant_john)
  end
  
  def test_it_contains_only_people
    assert_not_nil(@participants.find {|p| p.is_a? Participant})
    assert_nil(@participants.find {|p| p.is_a? ParticipantOrganization})
    assert_not_nil(@participants.find {|p| p.is_a? ParticipantPerson})
  end
  
  def test_it_is_participant_organiztion
    assert_instance_of(ParticipantPerson, @part_john)
  end
  
  def test_it_should_have_many_participant_contacts
    assert_not_nil(@part_john.participant_contacts)
    assert_instance_of(ParticipantContact, @part_john.participant_contacts[0]) 
  end
  
  def test_it_should_have_one_data_provider
    assert_not_nil(@part_john.data_provider)
    assert_instance_of(DataProvider, @part_john.data_provider)
  end
end
