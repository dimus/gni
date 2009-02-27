require File.dirname(__FILE__) + '/../test_helper'

class AccessTypeTest < ActiveSupport::TestCase
  def setup
    @access_type = access_types(:can_resolve_uri)
  end
  
  def test_is_should_have_many_access_rules
    assert_not_nil(@access_type.access_rules)
    assert_instance_of(AccessRule, @access_type.access_rules[0])
  end
end
