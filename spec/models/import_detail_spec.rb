require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImportDetail do
  before(:each) do
    @import_detail = ImportDetail.new
  end

  it "should be valid" do
    @import_detail.should be_valid
  end
end
