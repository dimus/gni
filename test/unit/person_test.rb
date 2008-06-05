require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase
  
  def setup 
    @john = people(:john)
    @jane = people(:jane)
  end
  
  def test_it_should_have_many_organization_memberships
    assert_not_nil(@john)
    assert_not_nil(@john.organization_memberships)
    assert_instance_of(OrganizationMembership, @john.organization_memberships[0])
  end
  
  def test_it_should_have_many_participant_contacts
    assert_not_nil(@john.participant_contacts)
    assert_instance_of(ParticipantContact, @john.participant_contacts[0])
  end
  
  def test_it_should_have_many_participant_people
    assert_not_nil(@john.participant_people)
    assert_instance_of(ParticipantPerson, @john.participant_people[0])
  end

end
