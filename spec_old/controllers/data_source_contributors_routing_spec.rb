require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DataSourceContributorsController do
  describe "route generation" do

    it "should map { :controller => 'data_source_contributors', :action => 'index' } to /data_source_contributors" do
      route_for(:controller => "data_source_contributors", :action => "index").should == "/data_source_contributors"
    end
  
    it "should map { :controller => 'data_source_contributors', :action => 'new' } to /data_source_contributors/new" do
      route_for(:controller => "data_source_contributors", :action => "new").should == "/data_source_contributors/new"
    end
  
    it "should map { :controller => 'data_source_contributors', :action => 'show', :id => 1 } to /data_source_contributors/1" do
      route_for(:controller => "data_source_contributors", :action => "show", :id => 1).should == "/data_source_contributors/1"
    end
  
    it "should map { :controller => 'data_source_contributors', :action => 'edit', :id => 1 } to /data_source_contributors/1/edit" do
      route_for(:controller => "data_source_contributors", :action => "edit", :id => 1).should == "/data_source_contributors/1/edit"
    end
  
    it "should map { :controller => 'data_source_contributors', :action => 'update', :id => 1} to /data_source_contributors/1" do
      route_for(:controller => "data_source_contributors", :action => "update", :id => 1).should == "/data_source_contributors/1"
    end
  
    it "should map { :controller => 'data_source_contributors', :action => 'destroy', :id => 1} to /data_source_contributors/1" do
      route_for(:controller => "data_source_contributors", :action => "destroy", :id => 1).should == "/data_source_contributors/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'data_source_contributors', action => 'index' } from GET /data_source_contributors" do
      params_from(:get, "/data_source_contributors").should == {:controller => "data_source_contributors", :action => "index"}
    end
  
    it "should generate params { :controller => 'data_source_contributors', action => 'new' } from GET /data_source_contributors/new" do
      params_from(:get, "/data_source_contributors/new").should == {:controller => "data_source_contributors", :action => "new"}
    end
  
    it "should generate params { :controller => 'data_source_contributors', action => 'create' } from POST /data_source_contributors" do
      params_from(:post, "/data_source_contributors").should == {:controller => "data_source_contributors", :action => "create"}
    end
  
    it "should generate params { :controller => 'data_source_contributors', action => 'show', id => '1' } from GET /data_source_contributors/1" do
      params_from(:get, "/data_source_contributors/1").should == {:controller => "data_source_contributors", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'data_source_contributors', action => 'edit', id => '1' } from GET /data_source_contributors/1;edit" do
      params_from(:get, "/data_source_contributors/1/edit").should == {:controller => "data_source_contributors", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'data_source_contributors', action => 'update', id => '1' } from PUT /data_source_contributors/1" do
      params_from(:put, "/data_source_contributors/1").should == {:controller => "data_source_contributors", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'data_source_contributors', action => 'destroy', id => '1' } from DELETE /data_source_contributors/1" do
      params_from(:delete, "/data_source_contributors/1").should == {:controller => "data_source_contributors", :action => "destroy", :id => "1"}
    end
  end
end
