require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameAuthorString do
  before(:each) do
    @name_author_string = NameAuthorString.new
  end

  it "should be valid" do
    @name_author_string.should be_valid
  end
end
