require File.dirname(__FILE__) + '/../spec_helper'

describe '/users' do
  before :all do
    Scenario.load :application
  end
  
  after :all do
    truncate_all_tables
  end
  
  it '/signup should render' do
    res = req('/signup')
    res.success?.should be_true
    res.body.should have_tag('form[action="/users"]') do
      with_tag 'input#user_login'
      with_tag 'input#user_email'
      with_tag 'input#user_password'
      with_tag 'input#user_password_confirmation'
      with_tag 'input[value="Sign Up"]'
    end
  end
  
  it 'should create new user' do
    count = User.count
    res = req('/users', :params => {
      'user[login]' => 'new_login',
      'user[email]' => 'example@new.com',
      'user[password]' => 'secret',
      'user[password_confirmation]' => 'secret',
    })
    res.redirect?.should be_true
    res.should redirect_to('/data_sources')
    User.count.should == count + 1
  end
  
  it '/user/edit should render ' do
    user = User.find_by_login('aaron')
    res = req("/users/#{user.id}/edit")
    res.success?.should be_true
    res.body.should have_tag('form[action=?]', "/users/#{user.id}") do
      with_tag 'input#user_email'
      with_tag 'input#user_password'
      with_tag 'input#user_password_confirmation'
      with_tag 'input[value="Save"]'
    end
  end
  
  it 'should update user' do
    user = User.find_by_login('aaron')
    res = request("/users/#{user.id}", :params => {'_method' => 'put', 'user[email]' => 'updated@example.com'})
    res.redirect?.should be_true
    res.should redirect_to('/data_sources')
    User.find_by_login('aaron').email.should == 'updated@example.com'
  end

end