require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_years/new.html.erb" do
  include NameYearsHelper
  
  before(:each) do
    @name_year = mock_model(NameYear)
    @name_year.stub!(:new_record?).and_return(true)
    @name_year.stub!(:year).and_return("1")
    @name_year.stub!(:unparsed).and_return("MyString")
    assigns[:name_year] = @name_year
  end

  it "should render new form" do
    render "/name_years/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", name_years_path) do
      with_tag("input#name_year_year[name=?]", "name_year[year]")
      with_tag("input#name_year_unparsed[name=?]", "name_year[unparsed]")
    end
  end
end


