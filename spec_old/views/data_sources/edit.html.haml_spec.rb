require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/data_sources/edit.html.haml" do
  
  before do
    ds = mock_model(DataSource, :refresh_period_days => 13, :data_url => "http://dataurl", :logo_url => "http://logourl", :metadata_url => "http://metaurl1", :web_site_url => "http://url1", :title => "Title1", :contributor? => true, :description => 'desc1')
    assigns[:data_source] = ds
  end
  
  it "should render" do
    render "/data_sources/edit.html.haml"
    response.should be_success 
  end
end
