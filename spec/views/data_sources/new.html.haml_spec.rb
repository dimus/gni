require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/data_sources/new.html.haml" do
  
  before(:each) do
    data_source = mock_model(DataSource)


    assigns[:data_source] = data_source
  end

  it "should render new form" do
    render "/data_sources/new.html.haml"

    response.should have_tag("form[action=?][method=post]", data_sources_path) do
      # with_tag("input#name_year_name_year[name=?]", "name_year[name_year]")
      # with_tag("input#name_year_is_confirmed[name=?]", "name_year[is_confirmed]")
    end
  end

end