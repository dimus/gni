require File.dirname(__FILE__) + '/../spec_helper'

describe ImportScheduler do

  before :all do
    Scenario.load :application
    Scenario.load :import_scheduler
  end
  
  after :all do
    truncate_all_tables
  end

  it "should find all data_sources scheduled for today" do
    data_sources_to_schedule = ImportScheduler.run_scheduler(true) #dry run
    data_sources_to_schedule.map {|ds| ds.id}.sort.should == [1,2,5,7]
  end

end
