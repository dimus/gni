require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/data_source_import_details/index.html.haml" do
  
  before(:each) do
    dsi = mock_model(DataSourceImport, :name => 'import name')
    ds = mock_model(DataSource, :title => 'data source title')
    sn1 = mock_model(NameString, :name => 'name1')
    sn2 = mock_model(NameString, :name => 'name2')
    dsid1 = mock_model(DataSourceImportDetail, :name_string => sn1)
    dsid2 = mock_model(DataSourceImportDetail, :name_string => sn2)
    assigns[:data_source_import] = dsi
    assigns[:data_source] = ds
    assigns[:data] = [dsid1,dsid2]
    template.stub!(:will_paginate).and_return('paginator')
  end


  it "should render with data" do
    render "/data_source_import_details/index.html.haml"
    response.should be_success
  end

  it "should render without data" do
    assigns[:data] = nil
    render "/data_source_import_details/index.html.haml"
    response.should be_success
  end

end
