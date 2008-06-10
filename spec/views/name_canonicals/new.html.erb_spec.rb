require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_canonicals/new.html.erb" do
  include NameCanonicalsHelper
  
  before(:each) do
    @name_canonical = mock_model(NameCanonical)
    @name_canonical.stub!(:new_record?).and_return(true)
    @name_canonical.stub!(:name).and_return("MyString")
    assigns[:name_canonical] = @name_canonical
  end

  it "should render new form" do
    render "/name_canonicals/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", name_canonicals_path) do
      with_tag("input#name_canonical_name[name=?]", "name_canonical[name]")
    end
  end
end


