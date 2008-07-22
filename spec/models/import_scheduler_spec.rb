require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImportScheduler do
  before(:each) do
    @import_scheduler = ImportScheduler.new
  end

  it "should be valid" do
    @import_scheduler.should be_valid
  end
end
