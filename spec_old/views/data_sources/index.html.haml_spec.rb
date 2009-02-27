require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/data_sources/index.html.haml" do
  
  before(:each) do
    ds1 = mock_model(DataSource, :web_site_url => "http://url1", :title => "Title1", :contributor? => true, :description => 'desc1')
    ds2 = mock_model(DataSource, :web_site_url => "http://url2", :title => "Title2", :contributor? => false, :description => 'desc2')
    ds3 = mock_model(DataSource, :web_site_url => "http://url3", :title => "Title3", :contributor? => false, :description => 'desc3')
    user = mock_model(User)
    assigns[:data_sources] = [ds1, ds2, ds3]
    assigns[:user] = user
    assigns[:user_data_sources] = [ds1]
  end


  it "should render without logged in user" do
    template.stub!(:logged_in?).and_return(false)
    render "/data_sources/index.html.haml" 
    response.should be_success
  end

  it "should render with logged in user" do
    template.stub!(:logged_in?).and_return(true)
    render "/data_sources/index.html.haml" 
    response.should be_success
  end
end
