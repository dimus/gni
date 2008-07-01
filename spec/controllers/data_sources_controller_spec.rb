require File.dirname(__FILE__) + '/../spec_helper'

describe DataSourcesController do
  fixtures :users
  
  describe ".create" do
    
    before(:each) do
      @metdata_url_params = {:metadata_url => File.dirname(__FILE__) + "/../fixtures/feeds/index_fungorum_data_source.xml"}
      @request.session[:user] = users(:aaron)
    end
    
    it 'should create data_source from supplied data if metadta_url is nil' do
      lambda do
        create_data_source
        response.should be_redirect
      end.should change(DataSource, :count).by(1)
    end

    it "should get data from xml if metadata_url is given" do
      lambda do
        create_data_source :title => nil, :metadata_url => File.dirname(__FILE__) + "/../fixtures/feeds/index_fungorum_data_source.xml"
        response.should be_redirect
      end.should change(DataSource, :count).by(1)      
    end

    it "should have data_url" do
      lambda do
        create_data_source :data_url => nil
        assigns[:data_source].errors.on(:data_url).should_not be_nil
        response.should be_success
      end.should_not change(DataSource, :count)
    end
    
    it "data_url should be url" do
      lambda do
        create_data_source :data_url => "ssh://example.com"
        assigns[:data_source].errors.on(:data_url).should_not be_nil
        response.should be_success
      end.should_not change(DataSource, :count)
    end

    it "should have title" do
      lambda do
        create_data_source :title => nil
        assigns[:data_source].errors.on(:title).should_not be_nil
        response.should be_success
      end.should_not change(DataSource, :count)
    end

    def create_data_source(options = {}) 
      post :create, :data_source => { :title => 'Index Fungorum', :description => 'Description',
      :data_url => 'http://example.com/data_url.xml', :data_zip_compressed => false, :metadata_url => nil, :logo_url => 'http://example.com/images/logo.png'}.merge(options)
    end
    
  end
  
  # describe ".edit" do
  #   before(:each) do
  #     @admin = mock(User)
  #     @admin.stub!(:id).and_return(50)
  #     @admin.stub!(:admin?).and_return(true)
  #     @contributor = mock(User)
  #     @contributor.stub!(:id).and_return(98)
  #     @reader = mock(User)
  #     @reader.stub!(:id).and_return(100)
  #     @data_source = mock(DataSource)
  #     @data_source.stub!(:id).and_return(200)
  #     @data_source.stub!(:contributor).and_return(@contributor)
  #   end
  #   
  #   it "should be accessible by admin" do
  #     session[:user_id] = @admin.id
  #     assigns[:data_source] = [@data_source]
  #     get 'edit'
  #   end
  #   
  #  
  # end
  
  describe ".delete" do
    it "should be accessible only by contributors and admin"
  end
end