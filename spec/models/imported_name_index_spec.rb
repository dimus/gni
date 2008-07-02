require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImportedNameIndex do
  before(:each) do
    @imported_name_index = ImportedNameIndex.new
  end

  it "should be valid" do
    @imported_name_index.should be_valid
  end
end
