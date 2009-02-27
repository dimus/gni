require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DataSourceImportDetail do
  before(:each) do
    @data_source_import_detail = DataSourceImportDetail.new
  end

  it "should be valid" do
    @data_source_import_detail.should be_valid
  end
end
