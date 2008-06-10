require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_canonicals/index.html.erb" do
  include NameCanonicalsHelper
  
  before(:each) do
    name_canonical_98 = mock_model(NameCanonical)
    name_canonical_98.should_receive(:name).and_return("MyString")
    name_canonical_99 = mock_model(NameCanonical)
    name_canonical_99.should_receive(:name).and_return("MyString")

    assigns[:name_canonicals] = [name_canonical_98, name_canonical_99]
  end

  it "should render list of name_canonicals" do
    render "/name_canonicals/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
  end
end

