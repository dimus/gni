require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_author_strings/index.html.erb" do
  include NameAuthorStringsHelper
  
  before(:each) do
    name_author_string_98 = mock_model(NameAuthorString)
    name_author_string_98.should_receive(:author_string).and_return("MyString")
    name_author_string_99 = mock_model(NameAuthorString)
    name_author_string_99.should_receive(:author_string).and_return("MyString")

    assigns[:name_author_strings] = [name_author_string_98, name_author_string_99]
  end

  it "should render list of name_author_strings" do
    render "/name_author_strings/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
  end
end

