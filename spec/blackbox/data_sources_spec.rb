require File.dirname(__FILE__) + '/../spec_helper'

describe '/data_sources' do

  before(:each) do
    #scenario :basic
    @resp = req( '/data_sources' )
  end
  
  it 'should render' do
    @resp.success?.should be_true
  end

end