require File.dirname(__FILE__) + '/../test_helper'

class ParticipantOrganizationTest < ActiveSupport::TestCase
  def setup
    @participants = ParticipantOrganization.find(:all)
    @part_nhm = participants(:participant_nhm)
  end
  
  def test_it_contains_only_organizations
    assert_not_nil(@participants.find {|p| p.is_a? Participant})
    assert_not_nil(@participants.find {|p| p.is_a? ParticipantOrganization})
    assert_nil(@participants.find {|p| p.is_a? ParticipantPerson})
  end
  
  def test_it_is_participant_organiztion
    assert_instance_of(ParticipantOrganization, @part_nhm)
  end
  
  def test_it_should_have_many_participant_contacts
    assert_not_nil(@part_nhm.participant_contacts);
    assert_instance_of(ParticipantContact, @part_nhm.participant_contacts[0]) 
  end
  
  def test_it_should_have_one_data_provider
    assert_not_nil(@part_nhm.data_provider)
    assert_instance_of(DataProvider, @part_nhm.data_provider)
  end
end
