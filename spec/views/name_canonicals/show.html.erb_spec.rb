require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_canonicals/show.html.erb" do
  include NameCanonicalsHelper
  
  before(:each) do
    @name_canonical = mock_model(NameCanonical)
    @name_canonical.stub!(:name).and_return("MyString")

    assigns[:name_canonical] = @name_canonical
  end

  it "should render attributes in <p>" do
    render "/name_canonicals/show.html.erb"
    response.should have_text(/MyString/)
  end
end

