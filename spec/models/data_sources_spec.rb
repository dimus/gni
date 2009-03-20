require File.dirname(__FILE__) + '/../spec_helper'
describe DataSource do
  before :all do 
    Scenario.load :application
  end
  
  after :all do
    truncate_all_tables
  end

  it "should require a valid #title" do
    DataSource.gen( :title => 'My Repository' ).should be_valid
    DataSource.build( :title => 'My Repository' ).should_not be_valid #is not unique
    DataSource.build( :title => nil).should_not be_valid #cannot be nil
  end
  
  it "should require a valid #data_url" do
    DataSource.gen( :data_url => "http://some.url/data.xml").should be_valid
    DataSource.build( :data_url => "http://some.url/data.xml").should_not be_valid #is not unique
    DataSource.build( :data_url => "someurl").should_not be_valid #not a url
    DataSource.build( :data_url => nil).should_not be_valid #cannot be nil
  end
  
  it "should have #logo_url as nil or url" do
    DataSource.gen(:logo_url => "http://some.url/data.som").should be_valid
    DataSource.build(:logo_url => "http://some.url/data.som").should be_valid #more than one of thes same logo is allowed
    DataSource.gen(:logo_url => nil).should be_valid
    DataSource.gen(:logo_url => nil).should be_valid #more than one nil is possible
    DataSource.build(:logo_url => 'not-url').should_not be_valid
  end
  
  it "should have #web_site_url as nil or url" do
    DataSource.gen(:web_site_url => "http://some.url/data.som").should be_valid
    DataSource.build(:web_site_url => "http://some.url/data.som").should be_valid #more than one of thes same logo is allowed
    DataSource.gen(:web_site_url => nil).should be_valid
    DataSource.gen(:web_site_url => nil).should be_valid #more than one nil is possible
    DataSource.build(:web_site_url => 'not-url').should_not be_valid
  end
  
  describe "contributor?" do
    before :all do
      @ds = DataSource.find_by_title('Index Fungorum')
      @user = User.find_by_login('aaron')
      @user2 = User.find_by_login('quentin')
      DataSourceContributor.gen(:data_source => @ds, :user => @user) rescue nil #TODO scenario does not load, fix in the framworkend 
    end
    
    it 'should find aaron as a contributor to Index Fungorum' do  
      @ds.contributor?(@user).should be_true
    end
  
    it 'should not find quentin as a contributor to Index Fungorum' do
      @ds.contributor?(@user2).should be_false
    end
  end
end
