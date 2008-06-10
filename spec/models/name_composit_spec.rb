require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NameComposit do
  before(:each) do
    @name_composit = NameComposit.new
  end

  it "should be valid" do
    @name_composit.should be_valid
  end
end
