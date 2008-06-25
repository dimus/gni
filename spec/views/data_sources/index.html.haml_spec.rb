require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/data_sources/index.html.haml" do
  
  before(:each) do
    data_source_98 = mock_model(DataSource)
    data_source_98.should_receive(:title).and_return("My Source")
    data_source_98.should_receive(:description).and_return("My Source desc")
    data_source_99 = mock_model(DataSource)
    data_source_99.should_receive(:title).and_return("Their Source")
    data_source_99.should_receive(:description).and_return("Their Source desc")

    assigns[:data_sources] = [data_source_98, data_source_99]
  end

  it "should render list of data_sources" do
    render "/data_sources/index.html.haml"
    response.should have_tag("tr>td", "My Source", 1)
    response.should have_tag("tr>td", "Their Source desc", 1)
  end
  
  it "should render Add link for logged user" do
    assigns[:current_user] = mock_model(User) #comebody logged in
    render "/data_sources/index.html.haml"
    response.should have_tag("a", "Add", 1)
  end
  
  it "should hide Add link for anonymous user" do
    assigns[:current_user] = nil
    render "/data_sources/index.html.haml"
    response.should_not have_tag("a", "Add")
  end
end