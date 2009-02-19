require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Statistic do
  before(:each) do
    @statistic = Statistic.new
  end

  it "should be valid" do
    @statistic.should be_valid
  end
end
