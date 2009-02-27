require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DataSourceImport do
  before(:each) do
    @data_source_import = DataSourceImport.new
  end

  it "should be valid" do
    @data_source_import.should be_valid
  end
end
