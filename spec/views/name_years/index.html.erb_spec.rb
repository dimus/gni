require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/name_years/index.html.erb" do
  include NameYearsHelper
  
  before(:each) do
    name_year_98 = mock_model(NameYear)
    name_year_98.should_receive(:year).and_return("1")
    name_year_98.should_receive(:unparsed).and_return("MyString")
    name_year_99 = mock_model(NameYear)
    name_year_99.should_receive(:year).and_return("1")
    name_year_99.should_receive(:unparsed).and_return("MyString")

    assigns[:name_years] = [name_year_98, name_year_99]
  end

  it "should render list of name_years" do
    render "/name_years/index.html.erb"
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

