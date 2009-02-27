require File.dirname(__FILE__) + '/../test_helper'

class OrganizationTest < ActiveSupport::TestCase
  
  def setup
    @nhm = organizations(:nhm)
    @eol = organizations(:eol)
  end
  
  def test_it_should_have_many_participant_organizations
    assert_not_nil(@nhm)
    assert_not_nil(@nhm.participant_organizations)
    assert_instance_of(ParticipantOrganization, @nhm.participant_organizations[0])
  end
  
  def test_it_should_have_many_organization_memberships
    assert_not_nil(@nhm.organization_memberships)
    assert_instance_of(OrganizationMembership, @nhm.organization_memberships[0])
  end
end
