require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameCanonical do
  before(:each) do
    @name_canonical = NameCanonical.new
  end

  it "should be valid" do
    @name_canonical.should be_valid
  end
end
