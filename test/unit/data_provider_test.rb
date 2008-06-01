require File.dirname(__FILE__) + '/../test_helper'

class DataProviderTest < ActiveSupport::TestCase
  def setup
    @bees_nhm_john = data_providers(:bees_nhm_john)
  end
  
  def test_it_should_have_many_roles
    assert_not_nil(@bees_nhm_john.data_provider_roles)
    assert_instance_of(DataProviderRole, @bees_nhm_john.data_provider_roles[0])
  end
end
