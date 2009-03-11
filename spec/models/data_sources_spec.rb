require File.dirname(__FILE__) + '/../spec_helper'
describe DataSource do

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

end

  # 
  # validates_presence_of :title, :message => "is required"
  # validate_uniqueness_of 
  # validates_presence_of :data_url, :message => "^Names Data URL is required"
  # validates_format_of :data_url, :with => URL_RE, :message => "^Names Data URL should be a URL"
  # validates_format_of :logo_url, :with => URL_RE, :message => "^Logo URL should be a URL"
  # validates_format_of :web_site_url, :with => URL_RE, :message => "^Website URL should be a URL"
