require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/data_source_contributors/edit.html.erb" do
  include DataSourceContributorsHelper
  
  before do
    @data_source_contributor = mock_model(DataSourceContributor)
    @data_source_contributor.stub!(:data_source).and_return()
    @data_source_contributor.stub!(:user).and_return()
    @data_source_contributor.stub!(:data_source_admin).and_return(false)
    assigns[:data_source_contributor] = @data_source_contributor
  end

  it "should render edit form" do
    render "/data_source_contributors/edit.html.erb"
    
    response.should have_tag("form[action=#{data_source_contributor_path(@data_source_contributor)}][method=post]") do
      with_tag('input#data_source_contributor_data_source[name=?]', "data_source_contributor[data_source]")
      with_tag('input#data_source_contributor_user[name=?]', "data_source_contributor[user]")
      with_tag('input#data_source_contributor_data_source_admin[name=?]', "data_source_contributor[data_source_admin]")
    end
  end
end


