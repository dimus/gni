require File.dirname(__FILE__) + '/../spec_helper'

describe NameString do
  fixtures :name_strings, :name_indices, :data_sources

  before do
    @name_string = name_strings(:bombus_fervidus)
  end

  it "should have many data_sources" do
    @name_string.data_sources.size.should > 0
  end
end
