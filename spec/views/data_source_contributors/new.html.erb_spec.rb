require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/data_source_contributors/new.html.erb" do
  include DataSourceContributorsHelper
  
  before(:each) do
    @data_source_contributor = mock_model(DataSourceContributor)
    @data_source_contributor.stub!(:new_record?).and_return(true)
    @data_source_contributor.stub!(:data_source).and_return()
    @data_source_contributor.stub!(:user).and_return()
    @data_source_contributor.stub!(:data_source_admin).and_return(false)
    assigns[:data_source_contributor] = @data_source_contributor
  end

  it "should render new form" do
    render "/data_source_contributors/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", data_source_contributors_path) do
      with_tag("input#data_source_contributor_data_source[name=?]", "data_source_contributor[data_source]")
      with_tag("input#data_source_contributor_user[name=?]", "data_source_contributor[user]")
      with_tag("input#data_source_contributor_data_source_admin[name=?]", "data_source_contributor[data_source_admin]")
    end
  end
end


