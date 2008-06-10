require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_author_strings/new.html.erb" do
  include NameAuthorStringsHelper
  
  before(:each) do
    @name_author_string = mock_model(NameAuthorString)
    @name_author_string.stub!(:new_record?).and_return(true)
    @name_author_string.stub!(:author_string).and_return("MyString")
    assigns[:name_author_string] = @name_author_string
  end

  it "should render new form" do
    render "/name_author_strings/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", name_author_strings_path) do
      with_tag("input#name_author_string_author_string[name=?]", "name_author_string[author_string]")
    end
  end
end


