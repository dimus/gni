require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Updater do
  before(:each) do
    @updater = Updater.new
  end

  it "should be valid" do
    @updater.should be_valid
  end
end
