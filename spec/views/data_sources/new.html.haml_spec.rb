require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/data_sources/new.html.haml" do
  before do
    ds1 = mock_model(DataSource, :data_url => "http://data_url", :logo_url => "http://logourl", :metadata_url => "http://metaurl1", :web_site_url => "http://url1", :title => "Title1", :contributor? => true, :description => 'desc1', :refresh_period_days => 14)
    assigns[:data_source] = ds1
  end

  it "should render" do
    render "/data_sources/new.html.haml" 
    response.should be_success
  end
end
