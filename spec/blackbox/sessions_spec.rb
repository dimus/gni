require File.dirname(__FILE__) + '/../spec_helper'

describe '/sessions/new' do

  before(:each) do
    #scenario :basic
    @resp = req( '/sessions/new' )
  end
  
  it 'should render' do
    @resp.success?.should be_true
  end

end