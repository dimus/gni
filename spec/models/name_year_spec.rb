require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameYear do
  before(:each) do
    @name_year = NameYear.new
  end

  it "should be valid" do
    @name_year.should be_valid
  end
end
