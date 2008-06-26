require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/data_source_contributors/index.html.erb" do
  include DataSourceContributorsHelper
  
  before(:each) do
    data_source_contributor_98 = mock_model(DataSourceContributor)
    data_source_contributor_98.should_receive(:data_source).and_return()
    data_source_contributor_98.should_receive(:user).and_return()
    data_source_contributor_98.should_receive(:data_source_admin).and_return(false)
    data_source_contributor_99 = mock_model(DataSourceContributor)
    data_source_contributor_99.should_receive(:data_source).and_return()
    data_source_contributor_99.should_receive(:user).and_return()
    data_source_contributor_99.should_receive(:data_source_admin).and_return(false)

    assigns[:data_source_contributors] = [data_source_contributor_98, data_source_contributor_99]
  end

  it "should render list of data_source_contributors" do
    render "/data_source_contributors/index.html.erb"
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", false, 2)
  end
end

