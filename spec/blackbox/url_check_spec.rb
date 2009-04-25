require File.dirname(__FILE__) + '/../spec_helper'

describe 'url_check' do 

  describe '/url_check' do
    
    it 'should return OK for existing url' do
      res = request('/url_check.xml?url=http://cnn.com')
      res.success?.should be_true
      res.body.should include('OK')
    end

    it 'should return "URL is NOT accessible" for invalid url' do
      res = request('/url_check.xml?url=not_url')
      res.success?.should be_true
      res.body.should include('URL is NOT accessible')
    end

  
  end
end

