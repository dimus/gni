require File.dirname(__FILE__) + '/../spec_helper'

describe 'feedback' do 

  describe '/feedback/new' do
    it 'should render without logged on user' do
      res = request('/feedback/new')
      res.success?.should be_true
      res.body.should have_tag('form[action="/feedback/send_feedback"]') do
        with_tag('input[name="email"][value=""]')
        with_tag('textarea[name="body"]')
        with_tag('input[type="submit"]')
      end
    end
  
    it 'should show email of logged user' do
      email = 'user@example.com'
      User.truncate
      User.gen(:login => 'user', :password => 'secret', :email => email)
      login_as(:login => 'user', :password => 'secret')
      res = request('/feedback/new')
      res.body.should have_tag('form[action="/feedback/send_feedback"]') do
        with_tag('input[name="email"][value=?]', email)
      end
    end
  end

  describe '/feedback/send_feedback' do
    before(:each) do  
      ActionMailer::Base.delivery_method = :test  
      ActionMailer::Base.perform_deliveries = true  
      ActionMailer::Base.deliveries = []  
    end
    
    it 'should send email and go to root' do
      res = request('/feedback/send_feedback', :params => {:email => 'some_email@example.com', :body => 'GNI helps me keep my names happy'})
      res.redirect?.should be_true
      puts '<pre>'
      puts ActionMailer::Base.deliveries.to_yaml
      puts '</pre>'
      ActionMailer::Base.deliveries.size.should == 1
    end
  end
end