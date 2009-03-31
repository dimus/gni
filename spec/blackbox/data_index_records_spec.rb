require File.dirname(__FILE__) + '/../spec_helper'

describe 'name_indices/1/name_index_records' do
  
  before :all do
    Scenario.load :application
  end
  
  after :all do
    truncate_all_tables
  end
  
  it 'should render' do
    res = req('/name_indices/1/name_index_records')
    res.success?.should be_true
    res.body.should include('GUID')
    res.body.should include('Adnaria frondosa')
    res.body.should have_tag('table')
  end
  
end