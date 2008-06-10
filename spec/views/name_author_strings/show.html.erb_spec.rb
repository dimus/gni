require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_author_strings/show.html.erb" do
  include NameAuthorStringsHelper
  
  before(:each) do
    @name_author_string = mock_model(NameAuthorString)
    @name_author_string.stub!(:author_string).and_return("MyString")

    assigns[:name_author_string] = @name_author_string
  end

  it "should render attributes in <p>" do
    render "/name_author_strings/show.html.erb"
    response.should have_text(/MyString/)
  end
end

