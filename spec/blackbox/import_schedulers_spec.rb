require File.dirname(__FILE__) + '/../spec_helper'

describe '/import_schedulers' do
  before :all do
    Scenario.load :application
    Scenario.load :import_scheduler
  end
  
  after :all do
    truncate_all_tables
  end
  
  describe 'index' do
    it 'should render' do
      res = request('/import_schedulers.xml')
      res.success?.should be_true
      res.body.should have_tag('refresh_period_days')
      res = request('/import_schedulers.json')
      res.success?.should be_true
      res.body.should include('"refresh_period_days":14,')
    end
  end

end