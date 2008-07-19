require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Imports do
  before(:each) do
    @imports = Imports.new
  end

  it "should be valid" do
    @imports.should be_valid
  end
end
