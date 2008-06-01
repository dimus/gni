require File.dirname(__FILE__) + '/../test_helper'

class DataSourceTest < ActiveSupport::TestCase
  def setup
    @data_source = data_sources(:bees_nhm)
  end
  
  def test_it_should_have_many_data_providers
    assert_not_nil(@data_source.data_providers)
    assert_instance_of(DataProvider, @data_source.data_providers[0])
  end
  
  def test_it_should_have_many_access_rules
    assert_not_nil(@data_source.access_rules)
    assert_instance_of(AccessRule, @data_source.access_rules[0])
  end
end
