require File.dirname(__FILE__) + '/../spec_helper'

describe DataSourcesController do
  
  describe ".create" do
    
    before(:each)
      @metdata_url_params = {:metadata_url => File.dirname(__FILE__) + "/../fixtures/feeds/index_fungorum_data_source.xml"}
    end
    
    it "should get data from xml if metadata_url is given"
      post :create, @metadata_ufl_params
      
    end
    
  end
  
end