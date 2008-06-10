require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_author_strings/edit.html.erb" do
  include NameAuthorStringsHelper
  
  before do
    @name_author_string = mock_model(NameAuthorString)
    @name_author_string.stub!(:author_string).and_return("MyString")
    assigns[:name_author_string] = @name_author_string
  end

  it "should render edit form" do
    render "/name_author_strings/edit.html.erb"
    
    response.should have_tag("form[action=#{name_author_string_path(@name_author_string)}][method=post]") do
      with_tag('input#name_author_string_author_string[name=?]', "name_author_string[author_string]")
    end
  end
end


