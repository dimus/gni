require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_canonicals/edit.html.erb" do
  include NameCanonicalsHelper
  
  before do
    @name_canonical = mock_model(NameCanonical)
    @name_canonical.stub!(:name).and_return("MyString")
    assigns[:name_canonical] = @name_canonical
  end

  it "should render edit form" do
    render "/name_canonicals/edit.html.erb"
    
    response.should have_tag("form[action=#{name_canonical_path(@name_canonical)}][method=post]") do
      with_tag('input#name_canonical_name[name=?]', "name_canonical[name]")
    end
  end
end


