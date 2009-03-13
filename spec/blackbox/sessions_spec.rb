require File.dirname(__FILE__) + '/../spec_helper'

describe '/sessions' do
  before :all do
    Scenario.load :application
  end
  
  after :all do
    truncate_all_tables
  end
  
  it 'should render' do
    res = request('/login')
    res.success?.should be_true
    res.body.should have_tag('form[action="/session"]') do
      with_tag('input#login')
      with_tag('input#password')
    end
  end
  
  it 'should display error message if credentials are wrong' do
    res = login_as(:login => 'wrong_user', :password => 'wrong_password')
    res.should be_successful
    res.body.should have_tag('div#flash') do
      with_tag('span.error')
    end
    res.body.should include("Couldn't log you in as 'wrong_user'") #brittle
  end
  
  it 'should aaron should login with password monkey' do
    res = login_as(:login => 'aaron', :password => 'monkey')
    res.redirect?.should be_true
    res.should redirect_to('/data_sources') #root_url did not work
  end
  
  it 'should be able to close session' do
    res = login_as(:login => 'aaron', :password => 'monkey')
    req('/').body.should have_tag('span#current_user_login_name') #added tag only to simplify testing
    req('/logout')
    req('/').body.should_not have_tag('span#current_user_login_name')
  end
  

end