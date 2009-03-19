require File.dirname(__FILE__) + '/../spec_helper'

describe DataSourceContributor do
  after :all do
    truncate_all_tables
  end

  it "should require a both user and data_source #name" do
    DataSourceContributor.build( :user => nil ).should_not be_valid
    DataSourceContributor.build( :data_source => nil ).should_not be_valid
  end

end

