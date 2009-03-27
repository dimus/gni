require File.dirname(__FILE__) + '/../spec_helper'

describe '/parsers' do
  describe 'new' do
    it 'should render' do
      res = request('/parsers/new')
      res.success?.should be_true
      res.body.should have_tag('form[method="get"]')
      res.body.should have_tag('form[action="/parsers"]') do
        with_tag('textarea#names')
        with_tag('input[value="Submit"]')
      end
    end
  end
  
  describe 'index' do
    it 'should render' do
      res = request('/parsers?names=Betula%20pubescens')
      res.success?.should be_true
      res.body.should include('"parse_succeeded":true')
    end
  end
end