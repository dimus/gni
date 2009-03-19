require File.dirname(__FILE__) + '/../spec_helper'

describe '/data_sources' do
  before :all do
    Scenario.load :application
  end
  
  after :all do
    truncate_all_tables
  end
  
  describe 'without loging in' do
    
    it 'should render' do
      res = req('/data_sources')
      res.success?.should be_true
      res.body.should include("Scientific Names Repositories")
      res.body.should_not include("Your Repositories")
    end
    
    it 'should show a repository settings' do
      repo = DataSource.find_by_title('ITIS')
      res = req("/data_sources/#{repo.id}")
      res.success?.should be_true
      res.body.should include("Repository &ldquo;ITIS&rdquo;")
      res.body.should_not include("Self-Harvesting")
    end
    
    it 'should not allow user to access form for creation of new repositories' do
      res = req("/data_sources/new")
      res.redirect?.should be_true
    end
    
    it 'should not allow user to create new repositories' do
      count = DataSource.count
      res = req("/data_sources", :params => { 'data_source[title]' => 'a title' })
      res.body.should  be_blank
      DataSource.count.should == count
    end
    
    it 'should not allow user to update a repository' do
      new_title = 'new_title'
      res = req("/data_sources/#{DataSource.last.id}", :params => { '_method' => 'put', 'data_source[title]' => new_title })
      res.body.should be_blank
      DataSource.last.title.should_not == new_title
    end
    
    it 'should not allow user to delete a repository' do
      DataSource.gen
      count = DataSource.count
      res = req("/data_sources/#{DataSource.last.id}", :params => { '_method' => 'delete' })
      DataSource.count.should == count
      res.body.should be_blank
    end
      
  end
  
  describe '/data_sources with logging in' do

    before :all do
      @user = User.find_by_login('aaron')
      @repo = @user.data_sources.first
      unless @repo #TODO fix it in the framwork! For some reason Scenario gets stackoverlow exception here
        DataSourceContributor.gen(:user => @user, :data_source => DataSource.first)
        @repo = DataSource.first
      end
      @others_repo = DataSource.all.select {|ds| !@user.data_sources.include? ds}.first
    end
    
    before :each do
      login_as(:login => 'aaron', :password => 'monkey')
    end

    it 'should show your repositories' do
      res = req("/data_sources")
      res.body.should include("Scientific Names Repositories")
      res.body.should include("Your Repositories")
      res.body.should include("add new repository")
    end

    it 'should show users their repositories' do
      res = req("/data_sources/#{@repo.id}")
      res.success?.should be_true
      res.body.should include("Repository &ldquo;#{@repo.title}&rdquo;")
      res.body.should include("Self-Harvesting")
    end
    
    it 'should show a form to create new repository' do
      res = req("/data_sources/new")
      res.success?.should be_true
      res.body.should have_tag('form[action="/data_sources"]') do
        with_tag('input#data_source_title')
        with_tag('input#data_source_data_url')
        with_tag('input#data_source_refresh_period_days')
        with_tag('textarea#data_source_description')
        with_tag('input#data_source_web_site_url')
        with_tag('input#data_source_logo_url')
        with_tag('input#data_source_submit[value="Create"]')
      end
    end
    
    it 'should be able to create a new repository' do
      count = DataSource.count
      res = req("/data_sources", :params =>{
        'data_source[title]' =>'New Title',
        'data_source[data_url]' =>'http://example.com/data.xml',
        'data_source[refresh_period_days]' =>'3'
      })
      res.redirect?.should be_true
      res.should redirect_to "/data_sources/#{DataSource.last.id}"
      DataSource.count.should == count + 1
    end
    
    it 'should show a for to edit a repository' do
      res = req("/data_sources/#{@repo.id}/edit")
      res.success?.should be_true
      res.body.should have_tag("form[action=?]", "/data_sources/#{@repo.id}") do
        with_tag('input') do
          '[value="put"]'
          '[name="_method"]'
        end
        with_tag('input#data_source_title')
        with_tag('input#data_source_data_url')
        with_tag('input#data_source_refresh_period_days')
        with_tag('textarea#data_source_description')
        with_tag('input#data_source_web_site_url')
        with_tag('input#data_source_logo_url')
        with_tag('input#data_source_submit[value="Update"]')
      end
    end
    
    it 'should be able to update their repository' do
      new_description = "new description #{rand}"
      res = req("/data_sources/#{@repo.id}", :params => {
        '_method' => 'put',
        'data_source[description]' => new_description
      })
      res.redirect?.should be_true
      res.should redirect_to("/data_sources/#{@repo.id}")
      DataSource.find(@repo.id).description.should == new_description 
    end
    
    it 'should be able to delete their repository' do
      new_repo = DataSource.gen
      DataSourceContributor.gen(:data_source_id => new_repo.id, :user_id => @user.id)
      count = DataSource.count
      req("/data_sources/#{new_repo.id}", :params => {'_method' => 'delete'})
      DataSource.count.should == count - 1
    end
    
    it 'should not see edit form for others repositories' do
      res = req("/data_sources/#{@others_repo.id}/edit")
      res.success?.should be_false
      res.redirect?.should be_true
      res.should redirect_to "/data_sources"    
    end
    
    it 'should not be able to update others repositories' do
      new_description = "new description #{rand}"
      res = req("/data_sources/#{@others_repo.id}", :params => {
        '_method' => 'put',
        'data_source[description]' => new_description
      })
      res.body.should == ''
      DataSource.find(@others_repo.id).description.should_not == new_description
    end
    
    it 'should not be able to delete others repositories' do
      count = DataSource.count
      res = req("/data_sources/#{@others_repo.id}", :params => {'_method' => 'delete'})
      DataSource.count.should == count
    end
    
  end

end
