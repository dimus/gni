require File.dirname(__FILE__) + '/../spec_helper'

describe ImportScheduler do

  before :all do
    Scenario.load :import_scheduler
  end
  
  after :all do
    truncate_all_tables
  end

  it "should find all data_sources scheduled for today" do
    data_sources_scheduled = ImportScheduler.data_sources_scheduled
  end

end
