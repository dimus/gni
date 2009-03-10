require File.dirname(__FILE__) + '/../spec_helper'

describe '/name_strings' do

  before(:each) do
    #scenario :basic
    @resp = req( '/name_strings' )
    @resp_xml = req('/name_strings.xml')
  end

  it 'should render' do
    @resp.success?.should be_true
    @resp_xml.success?.should be_true
  end

  it 'should be used as a root path' do
    @resp.body.should == req('/').body
  end

  it 'should have search box' do
    @resp.body.should have_tag('form[method=?]', 'get') do
      #search input
      with_tag('input[name=?]', 'search_term')
      #normal search button
      with_tag('input[name=?]', 'commit')
      with_tag('input[value=?]', 'Search')
      #without logging in -- no Search Mine button
      without_tag('input[value=?]', 'Search Mine')
    end 
  end
end