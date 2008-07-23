require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameIndexRecord do
  before(:each) do
    @name_index_record = NameIndexRecord.new
  end

  it "should be valid" do
    @name_index_record.should be_valid
  end
end
